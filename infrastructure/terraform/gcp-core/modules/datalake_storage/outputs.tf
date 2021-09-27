output "raw_bucket_name" {
  value       = google_storage_bucket.raw.name
  description = "Name of raw data bucket."
}

output "clean_bucket_name" {
  value       = google_storage_bucket.clean.name
  description = "Name of clean data bucket."
}

output "biascorrected_bucket_name" {
  value       = google_storage_bucket.biascorrected.name
  description = "Name of biascorrected production data bucket."
}

output "downscaled_bucket_name" {
  value       = google_storage_bucket.downscaled.name
  description = "Name of downscaled production data bucket."
}

output "qualitycontrol_bucket_name" {
  value       = google_storage_bucket.qualitycontrol.name
  description = "Name of qualitycontrol production data bucket."
}

output "support_bucket_name" {
  value       = google_storage_bucket.support.name
  description = "Name of support data bucket."
}

output "scratch_bucket_name" {
  value       = google_storage_bucket.scratch.name
  description = "Name of scratch bucket."
}

output "argo_cloudsql_instance_name" {
  value       = google_sql_database_instance.argo.name
  description = "Name of CloudSQL instance for Argo."
}

output "argo_cloudsql_private_ip_address" {
  value       = google_sql_database_instance.argo.private_ip_address
  description = "Private IP address of the CloudSQL instance for Argo."
}

output "argo_cloudsql_username" {
  description = "Argo CloudSQL instance user name."
  value       = google_sql_user.argo.name
  sensitive   = true
}

output "argo_cloudsql_password" {
  description = "Argo CloudSQL instance user password."
  value       = google_sql_user.argo.password
  sensitive   = true
}
