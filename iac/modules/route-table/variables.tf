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

variable "vnetNextHopeType" {
  type        = string
  description = "vnet type as next hope"
  default     = "VnetLocal"
}

variable "aksSubnetId" {
  type        = string
  description = "Subnet id that is associated to the route table"
}

variable "routeTableName" {
  type        = string
  description = "Route table name"
}

variable "fwpip" {
  type        = string
  description = "Firewall public IP"
}
