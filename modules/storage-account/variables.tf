variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "name" {
  type        = string
  description = "The the name of the resource"
}

variable "main_rg" {
  type        = string
  description = "The name of the resource group in which to create the subnet"
}

variable "virtual_network_subnet_ids" {
  description = "List of subnet IDs"
  type = list(string)
 }

variable "environment" {
  type = string
}

variable "name_of_pep" {
  type = string
  description = "Name of the private end point"
}

variable "subresource_name" {
  type        = string
  description = "subnet ids"
}

variable "private_dns_zone_ids" {
  type        = string
  description = "subnet ids"
}

variable "pep_subnet_ids" {
  type        = string
  description = "subnet ids that that is mapped to the private endpoint"
}

