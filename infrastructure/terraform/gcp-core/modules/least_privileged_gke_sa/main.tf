terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.79.0"
    }
  }
}

# Need to create a least-privilege Google Service Account to replace
# the default Google Compute Engine Service Account and its god-like
# permissions.
resource "google_service_account" "least_privilege_compute_sa" {
  account_id   = var.serviceaccount_id
  display_name = var.serviceaccount_id
  description  = "Least-privilege SA to for GKE. Managed by Terraform."
}

resource "google_project_iam_member" "lpcsa-logwriter-iammember" {
  member = "serviceAccount:${google_service_account.least_privilege_compute_sa.email}"
  role   = "roles/logging.logWriter"
}

resource "google_project_iam_member" "lpcsa-metricwriter-iammember" {
  member = "serviceAccount:${google_service_account.least_privilege_compute_sa.email}"
  role   = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "lpcsa-monitoringviewer-iammember" {
  member = "serviceAccount:${google_service_account.least_privilege_compute_sa.email}"
  role   = "roles/monitoring.viewer"
}

resource "google_project_iam_member" "lpcsa-resourceMetadatawriter-iammember" {
  member = "serviceAccount:${google_service_account.least_privilege_compute_sa.email}"
  role   = "roles/stackdriver.resourceMetadata.writer"
}

resource "google_artifact_registry_repository_iam_member" "lpcsa-artifactregistryreader-iammember" {
  provider   = google-beta
  location   = var.artifact_registry_location
  project    = var.artifact_registry_project
  repository = var.artifact_registry_name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.least_privilege_compute_sa.email}"
}
