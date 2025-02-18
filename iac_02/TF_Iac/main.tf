# Define Locals for Dynamic Naming
locals {
  rg_name      = "${var.project_name}-${var.environment}-rg"
  vnet_name    = "${var.project_name}-${var.environment}-vnet"
  frontend_nsg = "${var.project_name}-${var.environment}-frontend-nsg"
  backend_nsg  = "${var.project_name}-${var.environment}-backend-nsg"
  db_nsg       = "${var.project_name}-${var.environment}-db-nsg"
}


# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [lookup(var.address_space_map, var.environment)]
}

# Create Subnets
resource "azurerm_subnet" "frontend" {
  name                 = "${var.project_name}-${var.environment}-frontend-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [lookup(var.address_prefixes_map[var.environment], "frontend")]
}

resource "azurerm_subnet" "backend" {
  name                 = "${var.project_name}-${var.environment}-backend-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [lookup(var.address_prefixes_map[var.environment], "backend")]
}

resource "azurerm_subnet" "database" {
  name                 = "${var.project_name}-${var.environment}-database-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [lookup(var.address_prefixes_map[var.environment], "database")]
}

# Network Security Groups (NSGs)
resource "azurerm_network_security_group" "frontend_nsg" {
  name                = local.frontend_nsg
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-Limited-IPs"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefixes    = var.allowed_ips
    destination_address_prefix = "*"
    destination_port_range     = "80"
  }

  security_rule {
    name                       = "Deny-All"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}

# Attach NSG to Frontend Subnet
resource "azurerm_subnet_network_security_group_association" "frontend_assoc" {
  subnet_id                 = azurerm_subnet.frontend.id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}

# Backend NSG
resource "azurerm_network_security_group" "backend_nsg" {
  name                = local.backend_nsg
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-Frontend"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = azurerm_subnet.frontend.address_prefixes[0]
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }

  security_rule {
    name                       = "Deny-All"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}

# Attach NSG to Backend Subnet
resource "azurerm_subnet_network_security_group_association" "backend_assoc" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}

# Database NSG
resource "azurerm_network_security_group" "database_nsg" {
  name                = local.db_nsg
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-Backend"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = azurerm_subnet.backend.address_prefixes[0]
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }

  security_rule {
    name                       = "Deny-All"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}

# Attach NSG to Database Subnet
resource "azurerm_subnet_network_security_group_association" "database_assoc" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database_nsg.id
}