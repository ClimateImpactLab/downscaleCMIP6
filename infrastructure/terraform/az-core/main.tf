terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ClimateImpactLab"
    workspaces {
      name = "downscaleCMIP6-infra-az-core"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.77.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.5.0"
    }
  }
}

provider "azurerm" {
  use_msi = true
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    managed-by = "terraform"
  }
}

module "aks_cluster" {
  source              = "./modules/aks_cluster"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  k8scluster_name     = var.k8scluster_name
  kubernetes_version  = var.kubernetes_version
  aks_admin_group     = var.aks_admin_group

  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_container_registry" "acr" {
  name                = "downscaleCmip6"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  tags = {
    managed-by = "terraform"
  }
}

module "storage_account" {
  source               = "./modules/storage_account"
  storage_account_name = "dc6"
  resource_group_name  = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_resource_group.rg,
  ]
}
