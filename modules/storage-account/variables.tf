variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "name" {
  type        = string
  description = "The the name of the storage account"
}

variable "main_rg" {
  type        = string
  description = "The name of the resource group in which to create the subnet"
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
  nullable    = true
  default     = null
}

variable "environment" {
  type        = string
  description = "The deployment environment"
}

variable "private_endpoints" {
  type        = map(string)
  description = "A map of private endpoint subresource names to corresponding private dns zone names."
}

variable "pe_subnet_ids" {
  type        = string
  description = "subnet ids that that is mapped to the private endpoint"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Is public network access enabled for this storage account?"
  default     = false
}
