
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

variable "aksName" {
  type        = string
  description = "Azure Kubernetes Service name"
}

variable "aksSubnetId" {
  type        = string
  description = "The subnet id for hosting AKS"
}

variable "nodeVmSize" {
  type        = string
  description = "Node VM size"
  default     = "Standard_D2_v2"
}

variable "podCIDR" {
  type        = string
  description = "The pod CIDR"
  default     = "192.168.0.0/22"
}

variable "pluginMode" {
  type        = string
  description = "The network plugin mode"
  default     = "overlay"
}

variable "plugin" {
  type        = string
  description = "The plugin to be used for the AKS cluster"
  default     = "azure"
}

variable "dnsServiceIP" {
  type        = string
  description = "The DNS service IP"
  default     = "192.168.4.100"
}


variable "serviceCidr" {
  type        = string
  description = "The service CIDR"
  default     = "10.244.0.0/16"
}

variable "loadbalancerSku" {
  type        = string
  description = "The SKU of the Load Balancer"
  default     = "standard"
}

variable "networkPolicy" {
  type        = string
  description = "The network policy"
  default     = "azure"
}

variable "authorizedIpRanges" {
  type        = list(string)
  description = "Authorized IPs to access"
  default     = ["20.216.218.128/32"]
}
