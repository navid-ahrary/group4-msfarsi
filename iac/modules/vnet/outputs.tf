output "vnetAddressSpace" {
  value = var.addressSpaces
}

output "aksSubnetId" {
  value = azurerm_subnet.aksSubnet.id
}

output "fwSubnetId" {
  value = azurerm_subnet.fwSubnet.id
}

output "fwSubnetName" {
  value = azurerm_subnet.fwSubnet.name
}

output "aksSubnetAddressPrefixes" {
  value = var.aksSubnetAddressPrefixes
}
