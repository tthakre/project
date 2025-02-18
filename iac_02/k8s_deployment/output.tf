
# Output Values
output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_kubeconfig" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}

output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.db.name
}

output "kubernetes_namespace" {
  value = kubernetes_namespace.namespace.metadata[0].name
}