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


# Given to cert-manager on k8s to resolve DNS-01 challenges with CloudDNS.
# TODO: Should create custom minimal IAM role for this with: dns.resourceRecordSets.*, dns.changes.*, dns.managedZones.list
resource "random_id" "cert_manager_suffix" {
  byte_length = 4
}
resource "google_service_account" "cert_manager" {
  account_id   = "cert-manager-${random_id.cert_manager_suffix.hex}"
  description  = "Workload Identity service account for Kubernetes cert-manager to solve DNS01 challenges"
  display_name = "cert-manager"
}
resource "google_project_iam_member" "cert_manager-dnsadmin-iammember" {
  member = "serviceAccount:${google_service_account.cert_manager.email}"
  role   = "roles/dns.admin"
}
