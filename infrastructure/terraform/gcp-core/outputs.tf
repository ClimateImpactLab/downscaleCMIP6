output "vpc_id" {
  value = module.networking.vpc_id
}

output "publicsubnet_name" {
  value = module.networking.publicsubnet_name
}

output "publicsubnet_id" {
  value = module.networking.publicsubnet_id
}

output "services_range_name" {
  value = module.networking.services_range_name
}

output "pod_range_name" {
  value = module.networking.pod_range_name
}

output "artifact_registry_private_docker_repository_id" {
  value = module.artifact_registry.private_docker_repository_id
}

output "artifact_registry_private_docker_id" {
  value = module.artifact_registry.private_docker_id
}

output "artifact_registry_project" {
  value = module.artifact_registry.project
}

output "artifact_registry_location" {
  value = module.artifact_registry.location
}

output "gke_node_sa_email" {
  value = module.least_privileged_gke_sa.email
}

output "workflows_default_account_id" {
  value       = google_service_account.workflows_default.account_id
  description = "Argo Workflows worker service account ID."
}

output "workflows_default_email" {
  value       = google_service_account.workflows_default.email
  description = "Email to created Argo Workflows worker service account."
}

output "argo_cluster_name" {
  value       = module.gke_argo_cluster.cluster_name
  description = "Name of GKE Argo cluster."
}

output "argo_cluster_ca_certificate" {
  value       = module.gke_argo_cluster.cluster_ca_certificate
  description = "GKE Argo cluster CA certificate."
  sensitive   = true
}

output "argo_cluster_endpoint" {
  value       = module.gke_argo_cluster.endpoint
  description = "GKE Argo cluster endpoint address."
  sensitive   = true
}
