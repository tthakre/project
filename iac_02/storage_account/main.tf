# Create Storage Account for Terraform Backend
resource "azurerm_storage_account" "tfstate" {
  name                     = "${var.project_name}${var.environment}tfstate"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create Storage Container for State File
resource "azurerm_storage_container" "state_container" {
  name                  = var.container_name
  storage_account_id  = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}