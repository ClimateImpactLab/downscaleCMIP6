terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.79.0"
    }
  }
}


resource "random_id" "main_cluster_suffix" {
  byte_length = 4
}
resource "google_container_cluster" "main" {
  name = "${var.cluster_name_prefix}-${random_id.main_cluster_suffix.hex}"

  resource_labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  release_channel {
    channel = "RAPID"
  }

  maintenance_policy {
    recurring_window {
      end_time   = "2021-01-06T12:00:00Z"
      recurrence = "FREQ=WEEKLY"
      start_time = "2021-01-05T12:00:00Z"
    }
  }

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  # The default allocated node pool will try to use the Google Compute Default
  # Service Account, which we've disabled. So, need to hand it another
  # service account with minimal privileges.
  node_config {
    service_account = var.node_service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/userinfo.email"
    ]
  }
  lifecycle {
    ignore_changes = [node_config]
  }
}


resource "google_container_node_pool" "core" {
  name_prefix = "core-"
  project     = google_container_cluster.main.project
  cluster     = google_container_cluster.main.name
  location    = google_container_cluster.main.location

  initial_node_count = 1
  autoscaling {
    max_node_count = 10
    min_node_count = 1
  }
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  node_config {
    machine_type    = "e2-standard-2"
    image_type      = "COS_CONTAINERD"
    service_account = var.node_service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/userinfo.email"
    ]
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    labels = {
      "env"        = var.env
      "managed-by" = "terraform"
    }
  }
}


resource "google_container_node_pool" "worker8" {
  name_prefix = "worker8-"
  project     = google_container_cluster.main.project
  cluster     = google_container_cluster.main.name
  location    = google_container_cluster.main.location

  initial_node_count = 0
  autoscaling {
    max_node_count = 50
    min_node_count = 0
  }
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  node_config {
    machine_type    = "n1-highmem-8"
    preemptible     = true
    image_type      = "COS_CONTAINERD"
    service_account = var.node_service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/userinfo.email"
    ]
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    labels = {
      "env"        = var.env
      "managed-by" = "terraform"
      "dedicated"  = "worker"
    }

    taint = [
      {
        effect = "NO_SCHEDULE"
        key    = "dedicated"
        value  = "worker"
      },
    ]
  }
}


resource "google_container_node_pool" "worker" {
  name_prefix = "worker16-"
  project     = google_container_cluster.main.project
  cluster     = google_container_cluster.main.name
  location    = google_container_cluster.main.location

  initial_node_count = 0
  autoscaling {
    max_node_count = 50
    min_node_count = 0
  }
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  node_config {
    machine_type    = "n1-highmem-16"
    preemptible     = true
    image_type      = "COS_CONTAINERD"
    service_account = var.node_service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/userinfo.email"
    ]
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    labels = {
      "env"        = var.env
      "managed-by" = "terraform"
      "dedicated"  = "worker"
    }

    taint = [
      {
        effect = "NO_SCHEDULE"
        key    = "dedicated"
        value  = "worker"
      },
    ]
  }
}

resource "google_container_node_pool" "worker32" {
  name_prefix = "worker32-"
  project     = google_container_cluster.main.project
  cluster     = google_container_cluster.main.name
  location    = google_container_cluster.main.location

  initial_node_count = 0
  autoscaling {
    max_node_count = 50
    min_node_count = 0
  }
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  node_config {
    machine_type    = "n1-highmem-32"
    preemptible     = true
    image_type      = "COS_CONTAINERD"
    service_account = var.node_service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/userinfo.email"
    ]
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    labels = {
      "env"        = var.env
      "managed-by" = "terraform"
      "dedicated"  = "worker"
    }

    taint = [
      {
        effect = "NO_SCHEDULE"
        key    = "dedicated"
        value  = "worker"
      },
    ]
  }
}
