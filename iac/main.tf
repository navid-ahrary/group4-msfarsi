resource "random_string" "prefix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.location
}

module "vnet" {
  source            = "./modules/vnet"
  commonTags        = var.commonTags
  location          = var.location
  rgName            = var.rgName
  name              = "${var.vnetName}-${random_string.prefix.result}"
  aksSubnetName     = var.aksSubnetName
  firewallPrivateIP = module.firewall.privateIp
}

module "firewall" {
  source                   = "./modules/firewall"
  commonTags               = var.commonTags
  name                     = "${var.firewallName}-${random_string.prefix.result}"
  fwSubnetId               = module.vnet.fwSubnetId
  rgName                   = var.rgName
  location                 = var.location
  aksSubnetAddressPrefixes = module.vnet.aksSubnetAddressPrefixes
  logWorkspaceId           = module.monitor.logWorkspaceId
}

module "aks" {
  source             = "./modules/aks"
  name               = "${var.aksName}-${random_string.prefix.result}"
  rgName             = var.rgName
  aksSubnetId        = module.vnet.aksSubnetId
  commonTags         = var.commonTags
  location           = var.location
  nodeVmSize         = var.aksNodeVmSize
  authorizedIpRanges = concat(var.authorizedIpRanges, ["${module.firewall.fwpip}/32"])
  depends_on         = [module.firewall]
}

module "routeTable" {
  source            = "./modules/route-table"
  aksSubnetId       = module.vnet.aksSubnetId
  commonTags        = var.commonTags
  location          = var.location
  rgName            = var.rgName
  name              = "${var.routeTableName}-${random_string.prefix.result}"
  vnetAddressSpaces = module.vnet.vnetAddressSpace
  fwpip             = module.firewall.fwpip
  fwPrivateIp       = module.firewall.privateIp
  depends_on        = [module.aks, module.firewall]
}

module "monitor" {
  source             = "./modules/monitor"
  commonTags         = var.commonTags
  location           = var.location
  rgName             = var.rgName
  name               = "${var.logName}-${random_string.prefix.result}"
  logRetentionInDays = var.logRetentionInDays
}
