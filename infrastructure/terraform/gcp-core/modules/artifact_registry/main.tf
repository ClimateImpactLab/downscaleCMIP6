terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.79.0"
    }
  }
}


resource "google_artifact_registry_repository" "private_docker" {
  provider = google-beta

  location = var.location
  project  = var.project_id

  repository_id = var.private_docker_repository_name
  description   = "Private Docker images."
  format        = "DOCKER"

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}
