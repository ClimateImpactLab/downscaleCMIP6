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
  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
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


resource "google_storage_bucket" "raw_cmip6" {
  name                        = "raw-cmip6-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "raw_reanalysis" {
  name                        = "raw-reanalysis-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "clean_cmip6" {
  name                        = "clean-cmip6-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "clean_reanalysis" {
  name                        = "clean-reanalysis-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "biascorrected" {
  name                        = "biascorrected-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}



resource "google_storage_bucket" "biascorrectedstage" {
  name                        = "biascorrected-stage-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "stage"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "downscaled" {
  name                        = "downscaled-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "downscaledstage" {
  name                        = "downscaled-stage-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "stage"
    "managed-by" = "terraform"
  }
}



resource "google_storage_bucket" "support" {
  name                        = "support-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "qualitycontrol" {
  name                        = "qualitycontrol-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "qualitycontrolstage" {
  name                        = "qualitycontrol-stage-20210922"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    "env"        = "stage"
    "managed-by" = "terraform"
  }
}


resource "google_storage_bucket" "scratch" {
  name                        = "scratch-20210922"
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
    "env"        = "prod"
    "managed-by" = "terraform"
  }
}
