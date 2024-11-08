
variable "rgName" {
  type        = string
  description = "Resource group name"
}

variable "name" {
  type        = string
  description = "Azure Kubernetes Service name"
}

variable "location" {
  type        = string
  description = "Resource location"
}

variable "commonTags" {
  type        = map(string)
  description = "Resource tags"
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

variable "authorizedIpRanges" {
  type        = list(string)
  description = "Authorized IPs to access"
}
