output "raw_cmip6_bucket_name" {
  value       = google_storage_bucket.raw_cmip6.name
  description = "Name of raw-CMIP6 data bucket."
}

output "clean_cmip6_bucket_name" {
  value       = google_storage_bucket.clean_cmip6.name
  description = "Name of clean-CMIP6 data bucket."
}

output "raw_reanalysis_bucket_name" {
  value       = google_storage_bucket.raw_reanalysis.name
  description = "Name of raw-reanalysis data bucket."
}

output "clean_reanalysis_bucket_name" {
  value       = google_storage_bucket.clean_reanalysis.name
  description = "Name of clean-reanalysis data bucket."
}

output "biascorrected_bucket_name" {
  value       = google_storage_bucket.biascorrected.name
  description = "Name of biascorrected production data bucket."
}

output "biascorrected_stage_bucket_name" {
  value       = google_storage_bucket.biascorrectedstage.name
  description = "Name of biascorrected staging data bucket."
}

output "downscaled_bucket_name" {
  value       = google_storage_bucket.downscaled.name
  description = "Name of downscaled production data bucket."
}

output "downscaled_stage_bucket_name" {
  value       = google_storage_bucket.downscaledstage.name
  description = "Name of downscaled staging data bucket."
}

output "qualitycontrol_stage_bucket_name" {
  value       = google_storage_bucket.qualitycontrolstage.name
  description = "Name of qualitycontrol staging data bucket."
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
