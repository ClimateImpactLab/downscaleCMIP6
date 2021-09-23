variable "env" {
  type        = string
  description = "Brief environment label for tags and resource naming."
}

variable "project_id" {
  type        = string
  description = "GCP project name to provision."
}

variable "region" {
  type        = string
  description = "GCP region hosting provisioned resources."
}

variable "zone" {
  type        = string
  description = "GCP zone hosting provisioned resources."
}

variable "cluster_name_prefix" {
  type        = string
  description = "Prefix to use for GKE cluster name."
}

variable "network" {
  type        = string
  description = "VPC network ID to provision GKE cluster into."
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork ID to provision GKE cluster into."
}

variable "cluster_secondary_range_name" {
  type        = string
  description = "Name of secondary range to use for cluster pod IP allocation."
}

variable "services_secondary_range_name" {
  type        = string
  description = "Name of secondary range to use for cluster services IP allocation."
}

variable "node_service_account_email" {
  type        = string
  description = "Email for existing GCP Service Account to associate with GKE nodes."
}
