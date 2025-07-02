
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
  type        = map(any)
  description = "A map of subnet names to their properties: address_prefixes, service_endpoints and service_delegation."
}
