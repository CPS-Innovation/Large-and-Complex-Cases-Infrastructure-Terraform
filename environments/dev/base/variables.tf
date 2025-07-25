variable "subscription_env" {
  type        = string
  description = "The subscription's environment. Possible values are preprod and prod."
  validation {
    condition     = contains(["preprod", "prod"], var.subscription_env)
    error_message = "Invalid input for subscription_name. Possible values are preprod and prod."
  }
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network in which to create the subnet"
}

variable "vnet_rg" {
  type        = string
  description = "The name of the virtual network in which to create the subnet"
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

variable "nsg_rules" {
  type = map(object({
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  description = "A map of NSG rules to their properties. For destination and source addresses, either 'prefix' or 'prefixes' must be present."
}
