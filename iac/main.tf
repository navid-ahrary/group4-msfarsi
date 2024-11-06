resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.location
  tags     = var.commonTags
}

module "vnet" {
  source        = "./modules/vnet"
  commonTags    = var.commonTags
  location      = var.location
  rgName        = var.rgName
  vnetName      = var.vnetName
  aksSubnetName = var.aksSubnetName
}

module "aks" {
  source      = "./modules/aks"
  aksName     = var.aksName
  rgName      = var.rgName
  aksSubnetId = module.vnet.aksSubnetId
  commonTags  = var.commonTags
  location    = var.location
  nodeVmSize  = var.aksNodeVmSize
}

module "firewall" {
  source                   = "./modules/firewall"
  commonTags               = var.commonTags
  fwName                   = var.firewallName
  fwSubnetId               = module.vnet.fwSubnetId
  rgName                   = var.rgName
  location                 = var.location
  aksSubnetAddressPrefixes = module.vnet.aksSubnetAddressPrefixes
  aksApiServerAddress      = module.aks.apiServerAddress

  depends_on = [module.aks]
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

  depends_on = [module.aks, module.firewall]
}
