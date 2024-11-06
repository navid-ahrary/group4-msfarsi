locals {
  fwPIP                           = "${var.fwName}-pip"
  fwNetworkRuleCollectionName     = "${var.fwName}-NetRuleCollection"
  fwApplicationRuleCollectionName = "${var.fwName}-AppRuleCollection"
}

resource "azurerm_public_ip" "fwPIP" {
  name                = local.fwPIP
  location            = var.location
  resource_group_name = var.rgName
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = var.fwName
  resource_group_name = var.rgName
  location            = var.location
  sku_tier            = var.skuTier
  sku_name            = var.skuName

  dns_proxy_enabled = true

  ip_configuration {
    name                 = "pipConfig"
    subnet_id            = var.fwSubnetId
    public_ip_address_id = azurerm_public_ip.fwPIP.id
  }
}

resource "azurerm_firewall_network_rule_collection" "netRuleCollection" {
  resource_group_name = var.rgName
  name                = local.fwNetworkRuleCollectionName
  action              = "Allow"
  azure_firewall_name = azurerm_firewall.fw.name
  priority            = 100

  rule {
    name              = "allow-akstcp"
    protocols         = ["TCP"]
    source_addresses  = var.aksSubnetAddressPrefixes
    destination_fqdns = [var.aksApiServerAddress]
    destination_ports = ["9000", "443"]
  }

  rule {
    name              = "allow-aksudp"
    protocols         = ["UDP"]
    source_addresses  = var.aksSubnetAddressPrefixes
    destination_fqdns = [var.aksApiServerAddress]
    destination_ports = ["1194"]
  }

  rule {
    name              = "allow-ubuntuntpudp"
    destination_fqdns = ["ntp.ubuntu.com"]
    destination_ports = ["123"]
    protocols         = ["UDP"]
    source_addresses  = var.aksSubnetAddressPrefixes
  }
}

resource "azurerm_firewall_application_rule_collection" "appRuleCollection" {
  name                = local.fwApplicationRuleCollectionName
  resource_group_name = var.rgName
  action              = "Allow"
  azure_firewall_name = azurerm_firewall.fw.name
  priority            = 100

  rule {
    name             = "allow-aksmicrosoft"
    source_addresses = var.aksSubnetAddressPrefixes
    protocol {
      port = 443
      type = "Https"
    }
    target_fqdns = [
      "*.hcp.${var.location}.azmk8s.io", # Required for Node <-> API server communication.
      "management.azure.com",            # Required for Kubernetes operations against the Azure API.
      "login.microsoftonline.com",       # Required for Microsoft Entra authentication.
      "packages.microsoft.com",          # This address is the Microsoft packages repository used for cached apt-get operations
      "acs-mirror.azureedge.net",        # This address is for the repository required to download and install required binaries like kubenet and Azure CNI.
      "docker.io",                       # This address is for pulling docker image from Docker repository
      "registry-1.docker.io",            # This address is for pulling docker image from Docker repository
      "production.cloudflare.docker.com" # This address is for pulling docker image from Docker repository
    ]
  }
}

# data "azurerm_monitor_diagnostic_categories" "fw" {
#   resource_id = ""
# }
