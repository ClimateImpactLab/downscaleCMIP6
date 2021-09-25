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

variable "company" {
  type        = string
  description = "Abbreviated company or organization name."
}

variable "application" {
  type        = string
  description = "Organization project or application which resources are used for."
}

variable "subnet_range" {
  type        = string
  description = "CIDR IP range for subnet."
}

variable "services_range" {
  type        = string
  description = "CIDR IP range for subnet secondary IP range to use for VPC-enabled GKE cluster services."
}

variable "pod_ranges" {
  type        = string
  description = "CIDR IP range for subnet secondary IP range to use for VPC-enabled GKE cluster pods."
}

variable "dns_zone_name" {
  type        = string
  description = "Name of existing CloudDNS DNS zone to add subdomain record for argo server."
}

variable "argoserver_subdomain" {
  type        = string
  description = "Name of subdomain to append to dns_zone_name for argo server URL."
}
