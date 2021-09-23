output "email" {
  value       = google_service_account.least_privilege_compute_sa.email
  description = "Email to created GCP Service Account."
}
