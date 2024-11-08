output "fwpip" {
  depends_on  = [module.firewall]
  value       = module.firewall.fwpip
  sensitive   = true
  description = "Azure Firewall puplic IP served through internet"
}
