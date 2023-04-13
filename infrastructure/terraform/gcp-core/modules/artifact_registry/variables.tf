variable "env" {
  type        = string
  description = "Brief environment label for tags and resource naming."
}

variable "location" {
  type        = string
  description = "Location of Google Artifact Registry repository."
}

variable "project_id" {
  type        = string
  description = "Name of Google Project hosting the Artifact Registry."
}

variable "private_docker_repository_name" {
  default     = "private"
  type        = string
  description = "Name of Docker Google Artifact Registry repository to create."
}
