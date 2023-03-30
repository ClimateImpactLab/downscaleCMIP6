terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.79.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1.0"
    }
  }
}


resource "random_id" "argo_cloudsql_name_suffix" {
  byte_length = 4
}
resource "google_sql_database_instance" "argo" {
  provider = google-beta

  name             = "argo-${random_id.argo_cloudsql_name_suffix.hex}"
  database_version = "POSTGRES_13"
  region           = var.sql_region
  project          = var.project_id
  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
    backup_configuration {
      enabled = true
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.sql_vpc_id
    }
    user_labels = {
      "env"        = "prod"
      "managed-by" = "terraform"
    }
  }
}
resource "random_pet" "argodb_user" {
  keepers = {
    cloudsql_name = google_sql_database_instance.argo.name
  }
}
resource "random_password" "argodb_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
resource "google_sql_user" "argo" {
  name     = random_pet.argodb_user.id
  password = random_password.argodb_password.result
  instance = google_sql_database_instance.argo.name
}


resource "random_id" "raw_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "raw" {
  name                        = "raw-${random_id.raw_suffix.hex}"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}


resource "random_id" "clean_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "clean" {
  name                        = "clean-${random_id.clean_suffix.hex}"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "biascorrected_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "biascorrected" {
  name                        = "biascorrected-${random_id.biascorrected_suffix.hex}"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "downscaled_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "downscaled" {
  name                        = "downscaled-${random_id.downscaled_suffix.hex}"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "support_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "support" {
  name                        = "support-${random_id.support_suffix.hex}"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "qualitycontrol_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "qualitycontrol" {
  name                        = "qualitycontrol-${random_id.qualitycontrol_suffix.hex}"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "scratch_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "scratch" {
  name                        = "scratch-${random_id.scratch_suffix.hex}"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 15
    }
  }

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

# Buckets to migrate data storage to us-west1
resource "random_id" "raw2_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "raw2" {
  name                        = "raw-${random_id.raw2_suffix.hex}"
  location                    = "us-west1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}


resource "random_id" "clean2_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "clean2" {
  name                        = "clean-${random_id.clean2_suffix.hex}"
  location                    = "us-west1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "biascorrected2_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "biascorrected2" {
  name                        = "biascorrected-${random_id.biascorrected2_suffix.hex}"
  location                    = "us-west1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "downscaled2_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "downscaled2" {
  name                        = "downscaled-${random_id.downscaled2_suffix.hex}"
  location                    = "us-west1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "support2_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "support2" {
  name                        = "support-${random_id.support2_suffix.hex}"
  location                    = "us-west1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}

resource "random_id" "qualitycontrol2_suffix" {
  byte_length = 4
}
resource "google_storage_bucket" "qualitycontrol2" {
  name                        = "qualitycontrol-${random_id.qualitycontrol2_suffix.hex}"
  location                    = "us-west1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = var.env
    "managed-by" = "terraform"
  }
}
