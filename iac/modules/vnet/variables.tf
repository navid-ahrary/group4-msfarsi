variable "name" {
  type        = string
  description = "Resource name"
}

variable "location" {
  type        = string
  description = "Virtual network location"
}

variable "commonTags" {
  type        = map(string)
  description = "Virtual network tags"
}

variable "rgName" {
  type        = string
  description = "Resource group name"
}

variable "aksSubnetName" {
  type        = string
  description = "Subnet name that hosts AKS"
}

variable "addressSpaces" {
  type        = list(string)
  description = "VNet address spaces"
  default     = ["10.42.0.0/16"] # 10.42.0.0 - 10.42.255.255 (65,536 available IPs)
}

variable "aksSubnetAddressPrefixes" {
  type        = list(string)
  description = "AKS subnet prefix ip"
  default     = ["10.42.1.0/24"] # 10.0.0.0 - 10.0.0.255 : 256 ip addresses
}

variable "firewallSubnetAddressPrefixes" {
  type        = list(string)
  description = "Firewall subnet prefix ip"
  default     = ["10.42.2.0/26"] # Not changeable! 10.42.2.0 - 10.42.2.63 
}

variable "firewallPrivateIP" {
  type    = string
  default = "Firewall Private IP in this vnet"
}
