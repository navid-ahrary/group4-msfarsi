resource "azurerm_log_analytics_workspace" "logWorkspace" {
  name                = var.logName
  resource_group_name = var.rgName
  location            = var.location
  retention_in_days   = var.logRetentionInDays
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "actiongroup"
  resource_group_name = var.rgName
  short_name          = "example"

  email_receiver {
    name          = "navid"
    email_address = "navid.ahrary@outlook.com"
  }
}
