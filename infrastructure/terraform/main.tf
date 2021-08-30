terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ClimateImpactLab"
    workspaces {
      name = "downscaleCMIP6-infra"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.41.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "1.1.1"
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


# Public IP address for services from the cluster.
resource "azurerm_public_ip" "primary" {
  name                = "aksPublicIPAddress"
  location            = var.location
  sku                 = "Standard"
  resource_group_name = module.aks_cluster.node_resource_group
  allocation_method   = "Static"
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

resource "azurerm_role_assignment" "aksra" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_cluster.kubelet_id

  depends_on = [
    azurerm_container_registry.acr,
    module.aks_cluster
  ]
}

module "storage_account" {
  source               = "./modules/storage_account"
  storage_account_name = "dc6"
  resource_group_name  = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_resource_group.rg,
  ]
}

//module "kubernetes_internal" {
//  source                       = "./modules/kubernetes_internal"
//  host                         = module.aks_cluster.host
//  client_certificate           = base64decode(module.aks_cluster.client_certificate)
//  client_key                   = base64decode(module.aks_cluster.client_key)
//  cluster_ca_certificate       = base64decode(module.aks_cluster.cluster_ca_certificate)
//  climate_storage_account_name = module.storage_account.name
//  climate_storage_account_key  = module.storage_account.primary_access_key
//}
