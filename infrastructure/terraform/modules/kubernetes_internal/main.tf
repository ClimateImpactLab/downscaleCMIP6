terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.0.1"
    }
  }
}

provider "kubernetes" {
  host                   = var.host
  client_certificate     = var.client_certificate
  client_key             = var.client_key
  cluster_ca_certificate = var.cluster_ca_certificate
}

# Namespaces we deploy to later, usually outside TF.
resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
    labels = {
      managed-by = "terraform"
    }
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      managed-by = "terraform"
    }
  }
}


# Storage account credentials to be used by argo workflow workers
# for climate data access.
resource "kubernetes_secret" "workerstoragecreds" {
  metadata {
    name      = "workerstoragecreds-secret"
    namespace = kubernetes_namespace.argo.metadata[0].name
    labels = {
      managed-by = "terraform"
    }
  }
  data = {
    azurestorageaccount = var.climate_storage_account_name
    azurestoragekey     = var.climate_storage_account_key
  }

  depends_on = [
    kubernetes_namespace.argo,
  ]
}

# Storage account credentials for argo artifact repository
resource "kubernetes_secret" "artifactrepocreds" {
  metadata {
    name      = "artifactrepocreds-secret"
    namespace = kubernetes_namespace.argo.metadata[0].name
    labels = {
      managed-by = "terraform"
    }
  }
  data = {
    accesskey = var.climate_storage_account_name
    secretkey = var.climate_storage_account_key
  }

  depends_on = [
    kubernetes_namespace.argo,
  ]
}
