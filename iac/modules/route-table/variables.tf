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

variable "vnetAddressSpaces" {
  type        = list(string)
  description = "VNet address spaces that route table reacts to its traffic"
}

variable "vaNextHopeType" {
  type        = string
  description = "Virtual Appliance type as next hope"
  default     = "VirtualAppliance" # "VirtualNetworkGateway" "VnetLocal" "Internet" "VirtualAppliance" "None"
}

variable "aksSubnetId" {
  type        = string
  description = "Subnet id that is associated to the route table"
}

variable "routeTableName" {
  type        = string
  description = "Route table name"
}

variable "fwPrivateIp" {
  type        = string
  description = "Firewall private IP in vnet"
}

variable "fwpip" {
  type        = string
  description = "Firewall public IP"
}
