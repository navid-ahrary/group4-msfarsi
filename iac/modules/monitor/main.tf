resource "azurerm_log_analytics_workspace" "logWorkspace" {
  name                = var.logName
  resource_group_name = var.rgName
  location            = var.location
  sku                 = var.skuTier
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "fwDiagnostic" {
  name                           = "fw-diagnostic"
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.logWorkspace.id
  target_resource_id             = ""
  log_analytics_destination_type = ""
}
