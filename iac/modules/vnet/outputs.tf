output "vnetAddressSpace" {
  value = var.addressSpaces
}

output "aksSubnetId" {
  value = azurerm_subnet.aksSubnet.id
}

output "fwSubnetName" {
  value = azurerm_subnet.fwSubnet.name
}

output "fwSubnetId" {
  value = azurerm_subnet.fwSubnet.id
}

output "fwManagementSubnetId" {
  value = azurerm_subnet.fwManagementSubnet.id
}

output "aksSubnetAddressPrefixes" {
  value = var.aksSubnetAddressPrefixes
}
