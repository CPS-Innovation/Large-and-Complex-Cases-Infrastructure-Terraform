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

variable "fa_asp_sku" {
  type        = string
  description = "The SKU of the api function apps' App Service Plan. Must be one of: EP1, EP2, EP3"
  validation {
    condition     = can(regex("^EP[0-9]$", var.fa_asp_sku))
    error_message = "Invalid SKU. Only Elastic Premium plans can be selected. Please input one of EP1, EP2 or EP3"
  }
}

variable "fa_asp_max_elastic_worker_count" {
  type        = number
  description = "The maximum number of workers that can be used when scaling out the apps on the service plan"
}

variable "fa_asp_worker_count" {
  type        = number
  description = "The number of instances running each app on the service plan. Must be a multiple of availability zones in the region"
}
