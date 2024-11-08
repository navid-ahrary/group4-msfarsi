variable "rgName" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Public IP location"
}

variable "commonTags" {
  type        = map(string)
  description = "Public IP tags"
}

variable "fwSubnetId" {
  type        = string
  description = "The subnet id for hosting Firewall"
}

variable "fwManagementIpSubnetId" {
  type        = string
  description = "The subnet id for hosting Firewall Management IP"
}

variable "Sku" {
  type        = string
  description = "Public IP sku"
}

variable "fwManagementPipName" {
  type        = string
  description = "Firewall Mangement Public IP name"
}

variable "fwPipName" {
  type        = string
  description = "Firewall Public IP name"
}
