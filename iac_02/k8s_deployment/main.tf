provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

locals {
  linux_profile_admin_username = "deployment-${var.environment}"

}

# Deploy AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-${var.environment}-aks"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "${var.project_name}-${var.environment}-aks"
  automatic_upgrade_channel             = "None"
  node_os_upgrade_channel               = "None"

  linux_profile {
    admin_username = local.linux_profile_admin_username

    ssh_key {
      key_data = var.ssh_key
    }
  }

  default_node_pool {
    name           = "system"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = data.azurerm_subnet.aks_subnet.id
    min_count      = 1
    max_count      = 2
    max_pods       = 2
    node_labels    = var.sisense_build_node_label
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create Kubernetes Namespace
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
    labels = {
      environment = var.environment
      project     = var.project_name
    }
  }
}

#########################################################################
# Deploy MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "db" {
  name                   = "${var.project_name}-${var.environment}-mysql"
  location               = data.azurerm_resource_group.rg.location
  resource_group_name    = data.azurerm_resource_group.rg.name
  administrator_login    = var.mysql_admin_user
  administrator_password = var.mysql_admin_password
  sku_name               = "GP_Standard_D2s_v3"
  version                = "8.0"
  backup_retention_days  = 7
  delegated_subnet_id    = data.azurerm_subnet.db_subnet.id
  storage {
    size_gb = 32
  }
  high_availability {
    mode = "SameZone"
  }
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}