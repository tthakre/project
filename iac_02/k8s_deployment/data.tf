
# Fetch Existing Resource Group
data "azurerm_resource_group" "rg" {
  name = "${var.project_name}-${var.environment}-rg"
}

# Fetch Existing Virtual Network
data "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-${var.environment}-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Fetch Existing Subnets
data "azurerm_subnet" "aks_subnet" {
  name                 = "${var.project_name}-${var.environment}-backend-subnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "db_subnet" {
  name                 = "${var.project_name}-${var.environment}-database-subnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}