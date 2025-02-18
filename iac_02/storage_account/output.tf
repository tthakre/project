# Output Values
output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "container_name" {
  value = azurerm_storage_container.state_container.name
}

output "storage_account_key" {
  value     = azurerm_storage_account.tfstate.primary_access_key
  sensitive = true
}