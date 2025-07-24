variable "environment" {
  type        = string
  description = "The resource group name"
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network in which to create the subnet"
}

variable "vnet_rg" {
  type        = string
  description = "The name of the virtual network in which to create the subnet"
}

variable "nsg_lacc_name" {
  type        = string
  description = "Name of the Network Security Group"
}

variable "rt_lacc_name" {
  type        = string
  description = "Name of the Routing Table"
}

variable "subnets" {
  type = map(object({
    address_prefixes   = list(string)
    service_endpoints  = list(string)
    service_delegation = bool
  }))
  description = "A map of subnet names to their properties."
}
