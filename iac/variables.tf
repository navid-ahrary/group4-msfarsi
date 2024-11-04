variable "rgName" {
  type        = string
  description = "Resource group name"
  default     = "sch-Navid-Ahrary-rg"
}

variable "location" {
  type        = string
  description = "Resource group location"
  default     = "swedencentral"
}

variable "commonTags" {
  type        = map(string)
  description = "Resource group tags"
  default = {
    Department  = "IT"
    Environemnt = "demo"
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
  default     = "fw-egress"
}
