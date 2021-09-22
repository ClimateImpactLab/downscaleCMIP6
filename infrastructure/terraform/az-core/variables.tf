variable "prefix" {
  default     = "dc6"
  description = "A prefix used for all resources"
}

variable "location" {
  default     = "West Europe"
  description = "The Azure Region in which all resources are be provisioned"
}

variable "k8scluster_name" {
  default     = "amaterasu"
  description = "Name of the AKS cluster"
}

variable "kubernetes_version" {
  default     = "1.21.2"
  description = "The Kubernetes version to use in AKS"
}

variable "aks_admin_group" {
  description = "The Azure Active Directory group to give AKS cluster admin role"
}
