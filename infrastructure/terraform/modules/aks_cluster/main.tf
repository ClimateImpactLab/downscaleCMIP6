terraform {
  required_version = ">= 0.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.41.0"
    }
  }
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "loganalytics_workspace" {
  name                = "${var.prefix}-loganalytics-workspace"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  tags = {
    managed-by = "terraform"
  }
}

resource "azurerm_log_analytics_solution" "loganalytics_solution" {
  solution_name         = "Containers"
  workspace_resource_id = azurerm_log_analytics_workspace.loganalytics_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.loganalytics_workspace.name
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = data.azurerm_resource_group.main.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
  tags = {
    managed-by = "terraform"
  }
}

resource "azurerm_kubernetes_cluster" "k8scluster" {
  name                = "${var.prefix}-${var.k8scluster_name}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = "${var.k8scluster_name}-dns"

  default_node_pool {
    name                 = "core"
    node_count           = 1
    vm_size              = "Standard_B2S"
    enable_auto_scaling  = true
    min_count            = 1
    max_count            = 10
    orchestrator_version = var.kubernetes_version
  }

  identity {
    type = "SystemAssigned"
  }
  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
      admin_group_object_ids = [
        var.aks_admin_group
      ]
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.loganalytics_workspace.id
    }
    kube_dashboard {
      enabled = true
    }
  }
  tags = {
    managed-by = "terraform"
  }
  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count
    ]
  }
}

# resource "azurerm_kubernetes_cluster_node_pool" "nodepoolworker" {
#   name                  = "worker"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.k8scluster.id
#   orchestrator_version  = var.kubernetes_version
#   vm_size               = "Standard_E8as_v4"
#   node_count            = 0
#   enable_auto_scaling   = true
#   min_count             = 0
#   max_count             = 15
#   priority              = "Spot"
#   spot_max_price        = -1
#   eviction_policy       = "Delete"
#   node_labels = {
#     "kubernetes.azure.com/scalesetpriority" = "spot"
#     "dedicated"                             = "worker"
#   }
#   node_taints = [
#     "dedicated=worker:NoSchedule",
#     "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
#   ]
#   tags = {
#     managed-by = "terraform"
#   }
#   lifecycle {
#     ignore_changes = [
#       node_count
#     ]
#   }
# }
