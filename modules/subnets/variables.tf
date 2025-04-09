variable "location" {
  type        = string
  description = "The location of the virtual network"
}

variable "vnet_name" {
  type = string
  description = "The name of the virtual network in which to create the subnet"
}

variable "vnet_rg" {
  type = string
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

variable "subnet" {
  type = map(object({
    address_prefixes   = nunbers
    service_endpoints  = lst(string)
    service_delegation = false
  }))
  default = null
}
