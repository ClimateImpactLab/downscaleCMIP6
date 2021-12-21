terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ClimateImpactLab"
    workspaces {
      name = "downscaleCMIP6-infra-gcp-core"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.79.0"
    }
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}


module "artifact_registry" {
  source = "./modules/artifact_registry"

  private_docker_repository_name = "private"

  location   = var.region
  project_id = var.project_id
  env        = var.env
}

module "datalake_storage" {
  source = "./modules/datalake_storage"

  sql_vpc_id = module.networking.vpc_id
  sql_region = var.region

  project_id = var.project_id
  location   = var.region
  env        = var.env

  # The cloudsql instance depends on the VPC network connection being set up.
  depends_on = [module.networking]
}


module "networking" {
  source = "./modules/networking"

  subnet_range   = var.subnet_range
  services_range = var.services_range
  pod_ranges     = var.pod_ranges

  company     = var.company
  application = var.application

  env        = var.env
  project_id = var.project_id
  region     = var.region
}


module "least_privileged_gke_sa" {
  source = "./modules/least_privileged_gke_sa"

  serviceaccount_id = "gke-node"

  artifact_registry_location = module.artifact_registry.location
  artifact_registry_project  = module.artifact_registry.project
  artifact_registry_name     = module.artifact_registry.private_docker_repository_id
}


module "gke_argo_cluster" {
  source = "./modules/gke_argo_cluster"

  cluster_name_prefix = "tsukuyomi"

  network                       = module.networking.vpc_id
  subnetwork                    = module.networking.publicsubnet_id
  cluster_secondary_range_name  = module.networking.pod_range_name
  services_secondary_range_name = module.networking.services_range_name

  node_service_account_email = module.least_privileged_gke_sa.email

  env        = var.env
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}


# Service account to be used by Argo Workflows workers on Kubernetes
resource "random_id" "workflows_default_suffix" {
  byte_length = 4
}
resource "google_service_account" "workflows_default" {
  account_id   = "workflows-default-${random_id.workflows_default_suffix.hex}"
  description  = "Default Argo Workflow default worker service account"
  display_name = "workflows-default"
}
resource "google_storage_bucket_iam_member" "argoworker_buckets_iammember" {
  for_each = toset(
    [
      module.datalake_storage.raw_bucket_name,
      module.datalake_storage.clean_bucket_name,
      module.datalake_storage.biascorrected_bucket_name,
      module.datalake_storage.downscaled_bucket_name,
      module.datalake_storage.qualitycontrol_bucket_name,
      module.datalake_storage.scratch_bucket_name,
      module.datalake_storage.support_bucket_name
    ]
  )
  bucket = each.key
  member = "serviceAccount:${google_service_account.workflows_default.email}"
  role   = "roles/storage.admin"
}
resource "google_storage_bucket_iam_member" "argoworker_buckets_viewer_iammember" {
  for_each = toset(
    [
      module.datalake_storage.raw_bucket_name,
      module.datalake_storage.clean_bucket_name,
      module.datalake_storage.biascorrected_bucket_name,
      module.datalake_storage.downscaled_bucket_name,
      module.datalake_storage.qualitycontrol_bucket_name,
      module.datalake_storage.scratch_bucket_name,
      module.datalake_storage.support_bucket_name
    ]
  )
  bucket = each.key
  member = "serviceAccount:${google_service_account.workflows_default.email}"
  role   = "roles/storage.objectViewer"
}

# Service account for Argo Workflows server on Kubernetes.
# We need this so argo-server can read log from bucket storage.
resource "random_id" "argo_server_suffix" {
  byte_length = 4
}
resource "google_service_account" "argo_server" {
  account_id   = "argo-server-${random_id.argo_server_suffix.hex}"
  description  = "Argo Server service account"
  display_name = "argo-server"
}
resource "google_storage_bucket_iam_member" "argoserver_logread_iammember" {
  bucket = module.datalake_storage.scratch_bucket_name
  member = "serviceAccount:${google_service_account.argo_server.email}"
  role   = "roles/storage.objectViewer"
}
resource "google_service_account_iam_member" "argoserver_ksa_iammember" {
  service_account_id = google_service_account.argo_server.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[argo/argo-server]"
}


# So kubernetes-external-secrets-manager can access Secrets on Google Secret Manager
# and put into k8s Secrets.
resource "random_id" "kubernetes_external_secrets_suffix" {
  byte_length = 4
}
resource "google_service_account" "kubernetes_external_secrets" {
  account_id   = "k8s-external-secrets-${random_id.kubernetes_external_secrets_suffix.hex}"
  description  = "Workload Identity service account for kubernetes-external-secrets"
  display_name = "kubernetes-external-secrets"
}


# Create custom role and GCP service account to solve letsencrypt DNS01 challenges
# This service account is later expanded to a full Workload Identity service account
# bridging k8s and GCP.
resource "google_project_iam_custom_role" "dns01solver" {
  role_id     = "dns01solver"
  title       = "DNS01 Solver"
  description = "Role used to resolve dns01 challenges for cert-manager and TLS certificates"
  permissions = [
    "dns.resourceRecordSets.create",
    "dns.resourceRecordSets.delete",
    "dns.resourceRecordSets.get",
    "dns.resourceRecordSets.list",
    "dns.resourceRecordSets.update",
    "dns.changes.create",
    "dns.changes.get",
    "dns.changes.list",
    "dns.managedZones.list"
  ]
}
# Given to cert-manager on k8s to resolve DNS-01 challenges with CloudDNS.
resource "google_service_account" "dns01_solver" {
  account_id   = "dns01-solver"
  description  = "Workload Identity service account for Kubernetes cert-manager to solve DNS01 challenges"
  display_name = "dns01-solver"
}
resource "google_project_iam_member" "dns01_solver_rolebinding" {
  member = "serviceAccount:${google_service_account.dns01_solver.email}"
  role   = google_project_iam_custom_role.dns01solver.id
}
resource "google_project_iam_member" "cert_manager-dnsadmin-iammember" {
  member = "serviceAccount:${google_service_account.dns01_solver.email}"
  role   = "roles/dns.admin"
}

# GCP Service Account for Github Actions.
resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  description  = "Github Actions service account for Github Repository CI/CD"
  display_name = "github-actions"
}
# Let Github Actions release to Google Docker Repository.
resource "google_artifact_registry_repository_iam_member" "github_actions_artifactregistrywriter_iammember" {
  provider   = google-beta
  location   = module.artifact_registry.location
  project    = module.artifact_registry.project
  repository = module.artifact_registry.private_docker_repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.github_actions.email}"
}
