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

variable "nsg_hsk_name" {
  type        = string
  description = "Name of the Network Security Group"
}

variable "rt_hsk_name" {
  type        = string
  description = "Name of the Routing Table"
}

variable "subnets" {
  type = map(any)
  default = {
    subnet-lacc-service-staging = {
      address_prefixes   = ["10.7.167.96/27"]
      service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
      service_delegation = false
    }
    subnet-lacc-service-apps-staging = {
      address_prefixes   = ["10.7.167.192/27"]
      service_endpoints  = ["Microsoft.Storage"]
      service_delegation = true
    }
  }
}