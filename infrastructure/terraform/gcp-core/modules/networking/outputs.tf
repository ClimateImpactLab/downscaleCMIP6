output "vpc_id" {
  value = google_compute_network.vpc1.id
}

output "argoserver_static_ip" {
  value = google_compute_address.argoserver_staticip.address
}

output "publicsubnet_name" {
  value = google_compute_subnetwork.public1.name
}

output "publicsubnet_id" {
  value = google_compute_subnetwork.public1.id
}

output "services_range_name" {
  value = google_compute_subnetwork.public1.secondary_ip_range.0.range_name
}

output "pod_range_name" {
  value = google_compute_subnetwork.public1.secondary_ip_range.1.range_name
}
