terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ClimateImpactLab"
    workspaces {
      name = "downscaleCMIP6-infra-gcp-k8s"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.79.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
  }
}


data "terraform_remote_state" "gcp_core" {
  backend = "remote"

  config = {
    organization = "ClimateImpactLab"
    workspaces = {
      name = "downscaleCMIP6-infra-gcp-core"
    }
  }
}

data "google_client_config" "default" {}


provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.gcp_core.outputs.argo_cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.gcp_core.outputs.argo_cluster_ca_certificate)
}


resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "env"                          = var.env
    }
  }
}

resource "kubernetes_namespace" "argo_events" {
  metadata {
    name = "argo-events"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "env"                          = var.env
    }
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "env"                          = var.env
    }
  }
}


module "workflows_default_wli" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "16.0.1"

  use_existing_gcp_sa = true
  name                = "workflows-default"
  gcp_sa_name         = data.terraform_remote_state.gcp_core.outputs.workflows_default_account_id
  namespace           = kubernetes_namespace.argo.metadata.0.name

  project_id = var.project_id
}
