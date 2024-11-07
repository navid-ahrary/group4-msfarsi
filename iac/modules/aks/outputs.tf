output "apiServerAddress" {
  value     = regex("https://(.*?):", azurerm_kubernetes_cluster.aks.kube_config[0].host)[0]
  sensitive = true
}
