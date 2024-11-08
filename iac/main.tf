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

module "pip" {
  source                 = "./modules/public-ip"
  fwManagementPipName    = "${var.publicIpFwManagementName}-${random_string.prefix.result}"
  fwPipName              = "${var.publicIpFwName}-${random_string.prefix.result}"
  commonTags             = var.commonTags
  location               = var.location
  rgName                 = var.rgName
  fwManagementIpSubnetId = module.vnet.fwManagementSubnetId
  fwSubnetId             = module.vnet.aksSubnetId
  Sku                    = var.publicIPSku
}

module "firewall" {
  source                   = "./modules/firewall"
  commonTags               = var.commonTags
  name                     = "${var.firewallName}-${random_string.prefix.result}"
  rgName                   = var.rgName
  location                 = var.location
  aksSubnetAddressPrefixes = module.vnet.aksSubnetAddressPrefixes
  logWorkspaceId           = module.monitor.logWorkspaceId
  fwManagementPipId        = module.pip.fwManagementPipId
  fwManagementSubnetId     = module.vnet.fwManagementSubnetId
  fwSubnetId               = module.vnet.fwSubnetId
  fwPipId                  = module.pip.fwpPipId
  fwPipAddress             = module.pip.fwpPipAddress
}

module "aks" {
  source      = "./modules/aks"
  name        = "${var.aksName}-${random_string.prefix.result}"
  rgName      = var.rgName
  aksSubnetId = module.vnet.aksSubnetId
  commonTags  = var.commonTags
  location    = var.location
  nodeVmSize  = var.aksNodeVmSize
  authorizedIpRanges = concat(
    var.authorizedIpRanges,
    ["${module.pip.fwpPipAddress}/32", "${module.pip.fwManagementPipAddress}/32"]
  )
}

module "routeTable" {
  source            = "./modules/route-table"
  aksSubnetId       = module.vnet.aksSubnetId
  commonTags        = var.commonTags
  location          = var.location
  rgName            = var.rgName
  name              = "${var.routeTableName}-${random_string.prefix.result}"
  vnetAddressSpaces = module.vnet.vnetAddressSpace
  fwpip             = module.pip.fwpPipAddress
  fwPrivateIp       = module.firewall.privateIp

  depends_on = [module.aks]
}

module "monitor" {
  source                 = "./modules/monitor"
  commonTags             = var.commonTags
  location               = var.location
  rgName                 = var.rgName
  logName                = "${var.logName}-${random_string.prefix.result}"
  logRetentionInDays     = var.logRetentionInDays
  actionGroupName        = "${var.actionGroupName}-${random_string.prefix.result}"
  receiverEmailAddresses = var.actionGroupReceiverEmailAddresses
  fwId                   = module.firewall.fwId
  alertRuleName          = var.alertRuleName
}
