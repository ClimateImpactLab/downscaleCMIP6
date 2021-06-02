output "id" {
  value = azurerm_kubernetes_cluster.k8scluster.id
}

output "kubelet_id" {
  value = azurerm_kubernetes_cluster.k8scluster.kubelet_identity[0].object_id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8scluster.kube_config_raw
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.cluster_ca_certificate
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.k8scluster.kube_admin_config.0.host
}
