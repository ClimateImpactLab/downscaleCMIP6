output "name" {
  value = azurerm_storage_account.storageacc.name
}

output "primary_access_key" {
  value     = azurerm_storage_account.storageacc.primary_access_key
  sensitive = true
}
