resource "azurerm_virtual_network" "vnet" {
  name     = var.name
  location = var.location
  tags     = var.commonTags

  resource_group_name = var.rgName

  address_space = var.addressSpaces
}

resource "azurerm_subnet" "fwSubnet" {
  name = "AzureFirewallSubnet" # Not changeable! the name is forced by Azure

  resource_group_name = var.rgName

  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.firewallSubnetAddressPrefixes
}

resource "azurerm_subnet" "fwManagementSubnet" {
  name = "AzureFirewallManagementSubnet" # Not changeable! the name is forced by Azure

  resource_group_name = var.rgName

  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.firewallManagementSubnetAddressPrefixes
}

resource "azurerm_subnet" "aksSubnet" {
  name = var.aksSubnetName

  resource_group_name = var.rgName

  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aksSubnetAddressPrefixes
}

