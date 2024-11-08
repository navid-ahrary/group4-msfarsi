resource "azurerm_log_analytics_workspace" "logWorkspace" {
  name                = var.name
  resource_group_name = var.rgName
  location            = var.location
  retention_in_days   = var.logRetentionInDays
}
