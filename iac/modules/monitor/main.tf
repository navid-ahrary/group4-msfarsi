resource "azurerm_log_analytics_workspace" "logWorkspace" {
  name                = var.logName
  resource_group_name = var.rgName
  location            = var.location
  retention_in_days   = 30
}

data "azurerm_monitor_diagnostic_categories" "fw" {
  resource_id = var.fwId
}

resource "azurerm_monitor_diagnostic_setting" "fw" {
  name                           = "fw_diagnostic_setting"
  target_resource_id             = data.azurerm_monitor_diagnostic_categories.fw.resource_id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.logWorkspace.id
  log_analytics_destination_type = "Dedicated"

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.fw.metrics
    content {
      category = metric.value
    }
  }

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.fw.log_category_types
    content {
      category = enabled_log.value
    }
  }
}
