output "raw_cmip6_bucket_name" {
  value       = google_storage_bucket.raw_cmip6.name
  description = "Name of raw-CMIP6 data bucket."
}

output "clean_cmip6_bucket_name" {
  value       = google_storage_bucket.clean_cmip6.name
  description = "Name of clean-CMIP6 data bucket."
}

output "raw_reanalysis_bucket_name" {
  value       = google_storage_bucket.raw_cmip6.name
  description = "Name of raw-reanalysis data bucket."
}

output "clean_reanalysis_bucket_name" {
  value       = google_storage_bucket.clean_cmip6.name
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

output "scratch_bucket_name" {
  value       = google_storage_bucket.scratch.name
  description = "Name of scratch bucket."
}
