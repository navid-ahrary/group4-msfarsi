variable "rgName" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Resource group location"
}

variable "commonTags" {
  type        = map(string)
  description = "Resource group tags"
}

variable "logName" {
  type        = string
  description = "Log Workspace name"
}

variable "fwId" {
  type        = string
  description = "Firewall service id to enable diagnostic settings"
}
