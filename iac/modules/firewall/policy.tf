resource "azurerm_firewall_policy" "fwPolicy" {
  name                = "${var.name}-policy"
  location            = var.location
  resource_group_name = var.rgName
  tags                = var.commonTags
  sku                 = var.fwPolicySkuTier
}

resource "azurerm_firewall_policy_rule_collection_group" "fwPolicyNatRuleColletion" {
  name               = "nat-policy-group"
  priority           = 200
  firewall_policy_id = azurerm_firewall_policy.fwPolicy.id


  nat_rule_collection {
    name     = "dnat"
    action   = "Dnat"
    priority = 200

    rule {
      name                = "nat-aks-ilb"
      destination_address = var.fwPipAddress
      destination_ports   = ["80"]
      source_addresses    = ["*"]
      translated_address  = "10.42.1.20"
      translated_port     = 80
      protocols           = ["TCP", "UDP"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "fwPolicyApplicationRuleColletion" {
  name               = "app-policy-group"
  priority           = 200
  firewall_policy_id = azurerm_firewall_policy.fwPolicy.id


  application_rule_collection {
    name     = "allow-app-rule-collection"
    action   = "Allow"
    priority = 200

    rule {
      name = "microsoft-services"
      protocols {
        port = 443
        type = "Https"
      }
      source_addresses = var.aksSubnetAddressPrefixes
      destination_fqdns = [
        "*.hcp.${var.location}.azmk8s.io", # Required for Node <-> API server communication.
        "login.microsoftonline.com",       # Required for Microsoft Entra authentication.
        "acs-mirror.azureedge.net",        # This address is for the repository required to download and install required binaries like kubenet and Azure CNI.
        "packages.microsoft.com",          # This address is the Microsoft packages repository used for cached apt-get operations
        "dc.services.visualstudio.com",    # This endpoint is used by Azure Monitor for Containers Agent Telemetry.
        "management.azure.com",            # Required for Kubernetes operations against the Azure API.
        "mcr.microsoft.com",               # Required to access images in Microsoft Container Registry (MCR)
        "*.monitoring.azure.com",          # This endpoint is used to send metrics data to Azure Monitor
        "*.blob.storage.azure.net",        # This dependency is due to some internal mechanisms of Azure Managed Disks
        "*.blob.core.windows.net"          # This endpoint is used to store manifests for Azure Linux VM Agent & Extensions and is regularly checked to download new versions.
      ]
    }

    rule {
      name             = "node-update-http"
      source_addresses = var.aksSubnetAddressPrefixes

      protocols {
        port = 80
        type = "Http"
      }
      destination_fqdns = [
        "security.ubuntu.com",
        "azure.archive.ubuntu.com",
        "changelogs.ubuntu.com"
      ]
    }

    rule {
      name             = "node-update-https"
      source_addresses = var.aksSubnetAddressPrefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = [
        "snapshot.ubuntu.com"
      ]
    }

    rule {
      name             = "docker"
      source_addresses = var.aksSubnetAddressPrefixes
      protocols {
        port = 443
        type = "Https"
      }
      destination_fqdns = [
        "*docker.io",                       # This address is for authentication to docker hub and pulling image from Docker repository
        "registry-1.docker.io",             # This address is for pulling docker image from Docker repository
        "production.cloudflare.docker.com", # This address is for pulling docker image from Docker repository
      ]
    }

    rule {
      name             = "microsoft-com"
      source_addresses = var.aksSubnetAddressPrefixes

      protocols {
        type = "Https"
        port = 443
      }
      destination_fqdns = [
        "*microsoft.com"
      ]
    }
    rule {
      name             = "github"
      source_addresses = var.aksSubnetAddressPrefixes

      protocols {
        port = 443
        type = "Https"
      }

      destination_fqdns = [
        "ghcr.io",
        "pkg-containers.githubusercontent.com"
      ]
    }
  }

  application_rule_collection {
    name     = "deny-app-rule-collection"
    action   = "Deny"
    priority = 150

    rule {
      name             = "learn-microsoft-com"
      source_addresses = var.aksSubnetAddressPrefixes

      protocols {
        type = "Https"
        port = 443
      }
      destination_fqdns = [
        "learn.microsoft.com"
      ]
    }
  }
}

