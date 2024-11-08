variable "rgName" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Resource location"
}

variable "logName" {
  type        = string
  description = "Log Workspace name"
}

variable "commonTags" {
  type        = map(string)
  description = "Resource tags"
}

variable "logRetentionInDays" {
  type        = string
  default     = "30"
  description = "Data retention in days. 30 is usually the minimum allowed for basic needs."
}

variable "actionGroupName" {
  type        = string
  description = "Action group name"
}

variable "receiverEmailAddresses" {
  type        = list(string)
  description = "List of email addresses of alert receiver"
}

variable "fwId" {
  type        = string
  description = "Firewall Id for alerting"
}

variable "alertRuleName" {
  type        = string
  description = "Alert Rule name"
}
