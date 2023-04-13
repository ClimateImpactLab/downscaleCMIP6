variable "env" {
  type        = string
  description = "Brief environment label for tags and resource naming."
}

variable "project_id" {
  type        = string
  description = "GCP project name to deploy provision to."
}

variable "region" {
  type        = string
  description = "GCP region hosting network components."
}

variable "zone" {
  type        = string
  description = "GCP zone hosting provisioned resources."
}
