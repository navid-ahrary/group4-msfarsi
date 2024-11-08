data "azurerm_monitor_diagnostic_categories" "fw" {
  resource_id = azurerm_firewall.fw.id
}

resource "azurerm_monitor_diagnostic_setting" "fw" {
  name                           = "fw_diagnostic_setting"
  target_resource_id             = data.azurerm_monitor_diagnostic_categories.fw.resource_id
  log_analytics_workspace_id     = var.logWorkspaceId
  log_analytics_destination_type = "Dedicated" # Resource specific table

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.fw.metrics
    content {
      category = metric.value
    }
  }

  #   metric {
  #     category = "AllMetrics"
  #   }

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.fw.log_category_types
    content {
      category = enabled_log.value
    }
  }


  #   enabled_log {
  #     category = "AZFWApplicationRule"
  #   }
  #   enabled_log {
  #     category = "AZFWDnsQuery"
  #   }
  #   enabled_log {
  #     category = "AZFWFatFlow"
  #   }
  #   enabled_log {
  #     category = "AZFWFqdnResolveFailure"
  #   }
  #   enabled_log {
  #     category = "AZFWNatRule"
  #   }
  #   enabled_log {
  #     category = "AZFWNatRuleAggregation"
  #   }
}
