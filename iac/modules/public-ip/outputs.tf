output "fwpPipAddress" {
  value = azurerm_public_ip.fwPip.ip_address
}

output "fwpPipId" {
  value = azurerm_public_ip.fwPip.id
}

output "fwManagementPipAddress" {
  value = azurerm_public_ip.fwManagementPip.ip_address
}

output "fwManagementPipId" {
  value = azurerm_public_ip.fwManagementPip.id
}
