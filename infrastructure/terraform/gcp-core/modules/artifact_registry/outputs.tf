output "private_docker_repository_id" {
  value       = google_artifact_registry_repository.private_docker.repository_id
  description = "Name of private Docker Artifact Repository registry."
}

output "private_docker_id" {
  value       = google_artifact_registry_repository.private_docker.id
  description = "ID of private Docker Artifact Repository registry."
}

output "project" {
  value       = google_artifact_registry_repository.private_docker.project
  description = "Location of Docker Artifact Repository."
}

output "location" {
  value       = google_artifact_registry_repository.private_docker.location
  description = "Location Artifact Repository."
}
