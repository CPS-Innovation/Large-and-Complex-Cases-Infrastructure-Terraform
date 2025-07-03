variable "environment" {
  type        = string
  description = "The resource group name"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network in which to create the subnet"
}

variable "vnet_rg" {
  type        = string
  description = "The name of the virtual network in which to create the subnet"
}

variable "fa_sa_roles" {
  type        = set(string)
  description = "Role assignments for function apps on the storage account scope."
}
