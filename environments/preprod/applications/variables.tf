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

variable "private_dns_zones" {
  type        = map(string)
  description = "A map of private dns subresource name to their zone names"
}

variable "pe_subnet_name" {
  type        = string
  description = "The name of the subnet used for private endpoints. Possible values are subnet-lacc-service-common and subnet-lacc-service-prod."
  validation {
    condition     = contains(["subnet-lacc-service-common", "subnet-lacc-service-prod"], var.pe_subnet_name)
    error_message = "Invalid subnet name. Possible values are subnet-lacc-service-common and subnet-lacc-service-prod."
  }
}

variable "mpls_ingestion_access_mode" {
  type        = string
  description = "The default ingestion access mode for the associated private endpoints in scope. Possible values are Open and PrivateOnly."
  default     = "Open"
}

variable "mpls_query_access_mode" {
  type        = string
  description = "The default query access mode for hte associated private endpoints in scope. Possible values are Open and PrivateOnly."
  default     = "Open"
}
