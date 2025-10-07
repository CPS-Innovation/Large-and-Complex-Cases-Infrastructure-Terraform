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


variable "ado_sc_name" {
  type        = string
  description = "The name of the service principal used for deployment with Azure Pipelines"
}

variable "private_dns_zones" {
  type        = map(string)
  description = "A map of private dns subresource name to their zone names"
}

##### ui app #####

variable "ui_spa_always_on" {
  type        = bool
  description = "Should the app be kept warm during periods of inactivity?"
}

variable "ui_spa_pe_ip" {
  type        = string
  description = "A static private IP address to use for the UI SPA private endpoint."
  default     = null
}

variable "app_asp_sku" {
  type        = string
  description = "The SKU of the Linux App Service Plan."
}

variable "app_asp_max_elastic_worker_count" {
  type        = number
  description = "The maximum number of workers that can be used when scaling out the apps on the service plan."
  default     = null
}

variable "app_asp_zone_balancing_enabled" {
  type        = bool
  description = "Determines if zone balancing is enabled for the app service plan."
  default     = false
}

variable "app_asp_worker_count" {
  type        = number
  description = "The number of instances running each app on the service plan."
}

##### function apps #####

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

##### key vault #####

variable "kv_sku" {
  type        = string
  description = "The SKU for the key vault. Valid input: 'standard' or 'premium'."
}

variable "kv_purge_protection_enabled" {
  type        = bool
  description = "Is purge protection is enabled for the Key Vault? Once enabled, it cannot be disabled. If true, the vault will be retained for 90 days after deletion."
}

##### storage account #####

variable "sa_sku" {
  type        = string
  description = "The SKU of the storage account. Valid options are Standard and Premium."
}

variable "sa_replication" {
  type        = string
  description = "The type of replication to use for the storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
}

variable "blob_delete_retention" {
  type = object({
    days                     = number
    permanent_delete_enabled = bool
  })
  description = "The delete retention policy for the storage account"
}

variable "sa_key_access_enabled" {
  type        = bool
  description = "Is shared access key authorization enabled for the storage account?"
}
