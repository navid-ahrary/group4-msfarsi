data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name     = var.aksName
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
    os_sku                 = "AzureLinux"
    vnet_subnet_id         = var.aksSubnetId

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  dns_prefix = "${var.aksName}-dns"
  network_profile {
    load_balancer_sku   = var.loadbalancerSku
    network_plugin      = var.plugin
    network_plugin_mode = var.pluginMode
    service_cidr        = var.serviceCidr
    dns_service_ip      = var.dnsServiceIP
    pod_cidr            = var.podCIDR
    network_policy      = var.networkPolicy
  }

  identity {
    type = "SystemAssigned"
  }

  api_server_access_profile {
    authorized_ip_ranges = var.authorizedIpRanges
  }
}

