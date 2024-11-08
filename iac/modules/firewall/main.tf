resource "azurerm_public_ip" "fwPIP" {
  name                = local.fwPIP
  location            = var.location
  resource_group_name = var.rgName
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = var.name
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

resource "azurerm_firewall_network_rule_collection" "netRuleCollectionAllow" {
  resource_group_name = var.rgName
  name                = local.fwNetworkRuleCollectionName
  action              = "Allow"
  azure_firewall_name = azurerm_firewall.fw.name
  priority            = 110

  rule {
    name                  = "allow-akstcp"
    protocols             = ["TCP"]
    source_addresses      = var.aksSubnetAddressPrefixes
    destination_addresses = ["AzureCloud.${var.location}"]
    destination_ports     = ["9000"]
  }

  rule {
    name                  = "allow-aksudp"
    protocols             = ["UDP"]
    source_addresses      = var.aksSubnetAddressPrefixes
    destination_addresses = ["AzureCloud.${var.location}"]
    destination_ports     = ["1194"]
  }

  rule {
    name              = "allow-ubuntuntpudp"
    destination_fqdns = ["ntp.ubuntu.com"]
    destination_ports = ["123"]
    protocols         = ["UDP"]
    source_addresses  = var.aksSubnetAddressPrefixes
  }
}

resource "azurerm_firewall_application_rule_collection" "appRuleCollectionAllow" {
  name                = local.fwApplicationRuleCollectionNameAllow
  resource_group_name = var.rgName
  action              = "Allow"
  azure_firewall_name = azurerm_firewall.fw.name
  priority            = 110

  rule {
    name             = "allow-akstags"
    source_addresses = var.aksSubnetAddressPrefixes
    fqdn_tags        = ["AzureKubernetesService"]
  }

  rule {
    name             = "allow-microsoftservices"
    source_addresses = var.aksSubnetAddressPrefixes
    protocol {
      port = 443
      type = "Https"
    }
    target_fqdns = [
      "login.microsoftonline.com",    # Required for Microsoft Entra authentication.
      "acs-mirror.azureedge.net",     # This address is for the repository required to download and install required binaries like kubenet and Azure CNI.
      "packages.microsoft.com",       # This address is the Microsoft packages repository used for cached apt-get operations
      "dc.services.visualstudio.com", # This endpoint is used by Azure Monitor for Containers Agent Telemetry.
      "management.azure.com",         # Required for Kubernetes operations against the Azure API.
      "mcr.microsoft.com",            # Required to access images in Microsoft Container Registry (MCR)
      "*.monitoring.azure.com"        # This endpoint is used to send metrics data to Azure Monitor
    ]
  }

  rule {
    name             = "allow-microsoftblob"
    source_addresses = var.aksSubnetAddressPrefixes
    protocol {
      port = 443
      type = "Https"
    }
    target_fqdns = [
      "*.blob.storage.azure.net", # This dependency is due to some internal mechanisms of Azure Managed Disks
      "*.blob.core.windows.net",  # This endpoint is used to store manifests for Azure Linux VM Agent & Extensions and is regularly checked to download new versions.
    ]
  }

  rule {
    name             = "allow-docker"
    source_addresses = var.aksSubnetAddressPrefixes
    protocol {
      port = 443
      type = "Https"
    }
    target_fqdns = [
      "*docker.io",                       # This address is for authentication to docker hub and pulling image from Docker repository
      "registry-1.docker.io",             # This address is for pulling docker image from Docker repository
      "production.cloudflare.docker.com", # This address is for pulling docker image from Docker repository
    ]
  }

  rule {
    name             = "allow-microsoftcom"
    source_addresses = var.aksSubnetAddressPrefixes

    protocol {
      type = "Https"
      port = 443
    }

    target_fqdns = ["*microsoft.com"]
  }

  rule {
    name             = "allow-github"
    source_addresses = var.aksSubnetAddressPrefixes

    protocol {
      port = 443
      type = "Https"
    }

    target_fqdns = [
      "ghcr.io",
      "pkg-containers.githubusercontent.com"
    ]
  }
}

resource "azurerm_firewall_application_rule_collection" "appRuleCollectionDeny" {
  name                = local.fwApplicationRuleCollectionNameDeny
  resource_group_name = var.rgName
  action              = "Deny"
  azure_firewall_name = azurerm_firewall.fw.name
  priority            = 105

  rule {
    name             = "deny-learnmicrosoftcom"
    source_addresses = var.aksSubnetAddressPrefixes

    protocol {
      type = "Https"
      port = 443
    }

    target_fqdns = ["learn.microsoft.com"]
  }
}

resource "azurerm_firewall_nat_rule_collection" "natRuleCollectionDnat" {
  name                = local.fwDnatRuleCollectionName
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.rgName
  action              = "Dnat"
  priority            = 110
  rule {
    name                  = "allow-nataksilb"
    destination_addresses = [azurerm_public_ip.fwPIP.ip_address]
    destination_ports     = ["80"]
    source_addresses      = ["*"]
    translated_address    = "10.42.1.20"
    translated_port       = 80
    protocols             = ["TCP"]
  }
}
