output "fwPip" {
  value       = module.pip.fwpPipAddress
  sensitive   = true
  description = "Azure Firewall public IP"
}

output "fwManagementPip" {
  value       = module.pip.fwManagementPipAddress
  sensitive   = true
  description = "Azure Firewall Management public IP"
}
