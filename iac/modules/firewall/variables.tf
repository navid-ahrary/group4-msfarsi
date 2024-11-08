variable "rgName" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure Firewall location"
}

variable "name" {
  type        = string
  description = "Azure Firewall Service name"
}

variable "commonTags" {
  type        = map(string)
  description = "Azure Firewall tags"
}

variable "fwSubnetId" {
  type        = string
  description = "The subnet id for hosting Firewall"
}

variable "fwPipId" {
  type        = string
  description = "Firewall public IP"
}

variable "fwPipAddress" {
  type        = string
  description = "Firewall IP public address"
}

variable "fwManagementPipId" {
  type        = string
  description = "Firewall Management public IP"
}

variable "fwManagementSubnetId" {
  type        = string
  description = "The subnet id for hosting Firewall Management"
}

variable "fwSkuTier" {
  type        = string
  description = "Firewall SKU Tier"
  default     = "Basic"
}

variable "skuName" {
  type        = string
  description = "Firewall SKU Name"
  default     = "AZFW_VNet"
}

variable "aksSubnetAddressPrefixes" {
  type        = list(string)
  description = "AKS subnet address prefixes"
}

variable "logWorkspaceId" {
  type        = string
  description = "Log Analytics Workspace Id used for monitoring Firewall logs"
}

variable "fwPolicySkuTier" {
  type        = string
  description = "Firewall Policy SKU Tier"
  default     = "Basic"
}
