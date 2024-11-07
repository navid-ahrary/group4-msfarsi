output "fwpip" {
  value = azurerm_public_ip.fwPIP.ip_address
}

output "fwId" {
  value = azurerm_firewall.fw.id
}

output "privateIp" {
  value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}
