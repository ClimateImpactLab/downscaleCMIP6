terraform {
  required_version = ">= 0.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.41.0"
    }
  }
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "storageacc" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  allow_blob_public_access = "true"
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    managed-by = "terraform"
  }
}


resource "azurerm_storage_data_lake_gen2_filesystem" "raw" {
  name               = "raw"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "raw-cmip6" {
  name               = "raw-cmip6"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "raw-era5" {
  name               = "raw-era6"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "raw_era5" {
  name               = "raw-era5"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_data_lake_gen2_filesystem" "clean" {
  name               = "clean"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "clean-cmip6" {
  name               = "clean-cmip6"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "clean-era5" {
  name               = "clean-era5"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "clean-dev" {
  name               = "clean-dev"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = false
  }
}


resource "azurerm_storage_data_lake_gen2_filesystem" "biascorrected" {
  name               = "biascorrected"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "biascorrectedstage" {
  name               = "biascorrected-stage"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_data_lake_gen2_filesystem" "downscaled" {
  name               = "downscaled"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "downscaledstage" {
  name               = "downscaled-stage"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_data_lake_gen2_filesystem" "support" {
  name               = "support"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_data_lake_gen2_filesystem" "qc" {
  name               = "qualitycontrol"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_data_lake_gen2_filesystem" "qcstage" {
  name               = "qualitycontrol-stage"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_data_lake_gen2_filesystem" "scratch" {
  name               = "scratch"
  storage_account_id = azurerm_storage_account.storageacc.id
  lifecycle {
    prevent_destroy = true
  }
}

# Policy to remove blobs from scratch storage after a time.
resource "azurerm_storage_management_policy" "cleanscratch" {
  storage_account_id = azurerm_storage_account.storageacc.id

  rule {
    name    = "rule1"
    enabled = true
    filters {
      prefix_match = ["scratch/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 15
      }
    }
  }
}
