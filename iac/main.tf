resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.location
}

module "vnet" {
  source            = "./modules/vnet"
  commonTags        = var.commonTags
  location          = var.location
  rgName            = var.rgName
  vnetName          = var.vnetName
  aksSubnetName     = var.aksSubnetName
  firewallPrivateIP = module.firewall.privateIp
}

module "firewall" {
  source                   = "./modules/firewall"
  commonTags               = var.commonTags
  fwName                   = var.firewallName
  fwSubnetId               = module.vnet.fwSubnetId
  rgName                   = var.rgName
  location                 = var.location
  aksSubnetAddressPrefixes = module.vnet.aksSubnetAddressPrefixes
}

module "aks" {
  source             = "./modules/aks"
  aksName            = var.aksName
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
  routeTableName    = var.routeTableName
  vnetAddressSpaces = module.vnet.vnetAddressSpace
  fwpip             = module.firewall.fwpip
  fwPrivateIp       = module.firewall.privateIp
  depends_on        = [module.aks, module.firewall]
}

module "monitor" {
  source     = "./modules/monitor"
  commonTags = var.commonTags
  location   = var.location
  rgName     = var.rgName
  fwId       = module.firewall.fwId
  logName    = var.logName
}
