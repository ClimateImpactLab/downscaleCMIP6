variable "serviceaccount_id" {
  default     = "gke-node"
  type        = string
  description = "Service Account ID to use for creating GCP Service Account."
}

variable "artifact_registry_location" {
  type        = string
  description = "Location of Google Artifact Registry to bind permissions for."
}

variable "artifact_registry_project" {
  type        = string
  description = "Name of Google Project hosting the Artifact Registry to bind permissions for."
}

variable "artifact_registry_name" {
  type        = string
  description = "Name of Google Artifact Registry to bind permissions for."
}
