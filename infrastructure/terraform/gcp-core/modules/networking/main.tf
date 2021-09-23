terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.79.0"
    }
  }
}

# TODO: Should add `description` attrib to each one of these resources.

resource "google_compute_network" "vpc1" {
  name                    = "${var.company}-${var.application}-${var.env}-1"
  project                 = var.project_id
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
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
