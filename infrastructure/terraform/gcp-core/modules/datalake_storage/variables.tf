variable "env" {
  type        = string
  description = "Brief environment label for tags and resource naming."
}

variable "project_id" {
  type        = string
  description = "GCP project name to deploy provision to."
}

variable "location" {
  type        = string
  description = "GCP location hosting storage components."
}

variable "sql_region" {
  type        = string
  description = "GCP region to host the CloudSQL instance. Note, not all regions support CloudSQL."
}

variable "sql_vpc_id" {
  type        = string
  description = "VPC ID to attach Argo CloudSQL instance to."
}
