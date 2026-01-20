output "cluster_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "AKS cluster ID"
}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "AKS cluster name"
}

output "resource_group_name" {
  value       = azurerm_resource_group.aks.name
  description = "Resource group name"
}
