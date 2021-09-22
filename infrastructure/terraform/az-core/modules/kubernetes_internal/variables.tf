variable "host" {
  description = "The k8s cluster host"
  type        = string
}

variable "client_certificate" {
  description = "The k8s cluster client certificate"
  type        = string
  sensitive   = true
}

variable "client_key" {
  description = "The k8s cluster client key"
  type        = string
  sensitive   = true
}

variable "cluster_ca_certificate" {
  description = "The k8s cluster CA certificate"
  type        = string
  sensitive   = true
}

variable "climate_storage_account_name" {
  description = "Name of the Storage Account holding climate data"
  type        = string
}

variable "climate_storage_account_key" {
  description = "Access key to the Storage Account holding climate data"
  type        = string
  sensitive   = true
}
