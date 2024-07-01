output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kubernetes_cluster_location" {
  value = azurerm_kubernetes_cluster.aks.location
}

output "role_assignment_id" {
  value = azurerm_role_assignment.acr_pull.id
}
