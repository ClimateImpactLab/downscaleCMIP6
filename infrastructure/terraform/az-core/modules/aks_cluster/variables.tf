variable "prefix" {
  description = "A prefix used for all resources"
}

variable "resource_group_name" {
  description = "The resource group name to be imported"
  type        = string
}

variable "k8scluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version to use in AKS"
  type        = string
}

variable "aks_admin_group" {
  description = "The Azure Active Directory group to give AKS cluster admin role"
  type        = string
}
