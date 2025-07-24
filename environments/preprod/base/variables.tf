variable "environment" {
  type        = string
  description = "The resource group name"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

# variable "vnet_name" {
#   type        = string
#   description = "The name of the virtual network in which to create the subnet"
# }

variable "vnet_rg" {
  type        = string
  description = "The name of the virtual network in which to create the subnet"
}

# variable "rt_lacc_name" {
#   type        = string
#   description = "Name of the Routing Table"
# }

# variable "subnets" {
#   type        = map(any)
#   description = "A map of subnet names to their properties: address_prefixes, service_endpoints and service_delegation."
# }

variable "nsg_rules" {
  type = map(object({
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_ranges           = list(string)
    destination_port_ranges      = list(string)
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
}
