output "cluster_name" {
  value = google_container_cluster.main.name
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.main.master_auth[0].cluster_ca_certificate
  sensitive = true
}

output "endpoint" {
  value     = google_container_cluster.main.endpoint
  sensitive = true
}
