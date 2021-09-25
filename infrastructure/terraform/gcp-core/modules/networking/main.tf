terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.79.0"
    }
  }
}

# TODO: Should add `description` attrib to each one of these resources.

resource "random_id" "argoserver_suffix" {
  byte_length = 4
}
resource "google_compute_address" "argoserver_staticip" {
  name         = "argoserver-staticip-${random_id.argoserver_suffix.hex}"
  address_type = "EXTERNAL"
  region       = var.region
}

resource "google_compute_network" "vpc1" {
  name                    = "${var.company}-${var.application}-${var.env}-1"
  project                 = var.project_id
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_global_address" "argo_cloudsql_private_ip" {
  provider      = google-beta
  name          = "argo-cloudsql-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc1.id
  project       = var.project_id
}
# The connection is not automatically made, so we need to do this manually.
resource "google_service_networking_connection" "argo_cloudsql_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.vpc1.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.argo_cloudsql_private_ip.name]
}

resource "google_compute_subnetwork" "public1" {
  name          = "${var.company}-${var.application}-${var.env}-public-${var.region}"
  ip_cidr_range = var.subnet_range
  network       = google_compute_network.vpc1.id
  region        = var.region

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.services_range
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = var.pod_ranges
  }
}

resource "google_compute_firewall" "iap" {
  name      = "${var.company}-${var.application}-${var.env}-internet-internal-iap-22-3389-allow"
  network   = google_compute_network.vpc1.name
  priority  = 50000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}

resource "google_compute_firewall" "default-allow-internal" {
  name     = "${var.company}-${var.application}-${var.env}-internal-allow"
  network  = google_compute_network.vpc1.name
  priority = 65534
  source_ranges = [
    var.subnet_range,
  ]
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}
