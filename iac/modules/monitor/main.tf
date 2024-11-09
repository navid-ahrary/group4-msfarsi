resource "azurerm_log_analytics_workspace" "logWorkspace" {
  name                = var.logName
  resource_group_name = var.rgName
  location            = var.location
  retention_in_days   = var.logRetentionInDays
}

resource "azurerm_monitor_action_group" "actionGroup" {
  name                = var.actionGroupName
  resource_group_name = var.rgName
  short_name          = "action-group"
  tags                = var.commonTags

  dynamic "email_receiver" {
    for_each = var.receiverEmailAddresses

    content {
      name          = "receiver-${email_receiver.value}"
      email_address = email_receiver.value
    }
  }
}


resource "azurerm_monitor_scheduled_query_rules_alert" "firewallAlert" {
  name                = var.alertRuleName
  resource_group_name = var.rgName
  location            = var.location
  tags                = var.commonTags

  data_source_id = var.fwId
  action {
    action_group = [azurerm_monitor_action_group.actionGroup.id]
  }

  query = <<-QUERY
    AZFWApplicationRule 
    | where Action == "Deny"
  QUERY

  description = "Alert for denied FQDN Azure Firewall log entries"
  severity    = 0 # Critical
  frequency   = 5 # Check every 5 minutes
  time_window = 5 # Over a 5-minutes window

  trigger {
    threshold = 1
    operator  = "GreaterThanOrEqual"
  }
}
