variable "rgName" {
  type        = string
  description = "Resource group name"
  default     = "sch-Navid-Ahrary-rg"
}

variable "location" {
  type        = string
  description = "Resource group location"
  default     = "westus2"
}

variable "commonTags" {
  type        = map(string)
  description = "Resource group tags"
  default = {
    Department  = "IT"
    Environment = "demo"
  }
}

variable "vnetName" {
  type        = string
  description = "Virtual network name"
  default     = "vnet-egress"
}

variable "aksSubnetName" {
  type        = string
  description = "Subnet name that hosts AKS"
  default     = "aks-subnet"
}

variable "routeTableName" {
  type        = string
  description = "Route table name"
  default     = "rt-egress"
}

variable "aksName" {
  type        = string
  description = "Azure Kubernetes Service name"
  default     = "aks-egress"
}

variable "aksNodeVmSize" {
  type        = string
  description = "Node VM size"
  default     = "Standard_D2s_v3"
}

variable "firewallName" {
  type        = string
  description = "Azure Firewall name"
  default     = "afw-egress"
}

variable "logName" {
  type        = string
  description = "Log Analytic Workspace name"
  default     = "log-egress"
}

variable "actionGroupName" {
  type        = string
  description = "Action group name"
  default     = "ag-egress"
}

variable "actionGroupReceiverEmailAddresses" {
  type        = list(string)
  description = "List of email addresse as receiver of action group"
}


variable "alertRuleName" {
  type        = string
  description = "Log Alert Rule name"
  default     = "apr-egress"
}

variable "authorizedIpRanges" {
  type        = list(string)
  description = "Authorized IP Addresses to access AKS API server"
  default     = []
}

variable "logRetentionInDays" {
  type        = string
  default     = "30"
  description = "Data retention in days. 30 is usually the minimum allowed for basic needs."
}

variable "publicIpFwName" {
  type        = string
  description = "Public IP name for Firewall"
  default     = "pip-egress-afw"
}


variable "publicIpFwManagementName" {
  type        = string
  description = "Public IP name for Firewall Management"
  default     = "pip-egress-afw-managment"
}

variable "publicIPSku" {
  type        = string
  description = "Public IP sku"
  default     = "Standard"
}
