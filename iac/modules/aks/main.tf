data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name     = var.name
  location = var.location
  tags     = var.commonTags

  resource_group_name = var.rgName

  sku_tier                  = "Free"
  kubernetes_version        = data.azurerm_kubernetes_service_versions.current.default_version
  node_os_upgrade_channel   = "NodeImage"
  automatic_upgrade_channel = "stable"

  default_node_pool {
    name                 = "nodepool"
    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 3
    vm_size              = var.nodeVmSize

    node_public_ip_enabled = false
    os_sku                 = "AzureLinux" # options: "AzureLinux", "Ubuntu"
    vnet_subnet_id         = var.aksSubnetId

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  dns_prefix = "${var.name}-dns"
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    service_cidr        = "192.168.0.0/24" # 256 available IPs, Must not overlap with any subnet ranges in the vnet
    dns_service_ip      = "192.168.0.10"
    network_policy      = "azure" # Options: "calico" "azure" "cilium" (Calico is available with Azure CNI)
  }

  identity {
    type = "SystemAssigned"

  }

  api_server_access_profile {
    authorized_ip_ranges = var.authorizedIpRanges
  }
}

resource "azurerm_role_assignment" "networkContributorAks" {
  scope                = var.aksSubnetId
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}
