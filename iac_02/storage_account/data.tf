# Fetch Existing Resource Group
data "azurerm_resource_group" "rg" {
  name = "${var.project_name}-${var.environment}-rg"
}