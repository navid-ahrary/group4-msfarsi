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

variable "fwName" {
  type        = string
  description = "Azure Firewall Service name"
}

variable "fwSubnetId" {
  type        = string
  description = "The subnet id for hosting Firewall"
}

variable "skuTier" {
  type        = string
  description = "Firewall SKU Tier"
  default     = "Standard"
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

variable "aksApiServerAddress" {
  type        = string
  description = "AKS API server address"
}
