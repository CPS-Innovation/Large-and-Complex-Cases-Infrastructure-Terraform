variable "environment" {
  type        = string
  description = "The resource group name"
}

variable "subscription_env" {
  type        = string
  description = "The subscription's environment. Possible values are preprod and prod."
  validation {
    condition     = contains(["preprod", "prod"], var.subscription_env)
    error_message = "Invalid input for subscription_name. Possible values are preprod and prod."
  }
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


variable "ado_sc_obj_id" {
  type        = string
  description = "The object ID of the service principal used for deployment with Azure Pipelines"
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.ado_sc_obj_id))
    error_message = "The value given is not in the format of a valid object id."
  }
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
  default     = "null"
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

variable "sa_public_network_access_enabled" {
  type        = bool
  description = "Is public network access enabled to the storage account?"
}

variable "mpls_settings" {
  type = object({
    create_resource       = bool
    ingestion_access_mode = string
    query_access_mode     = string
    pe_subnet             = string
  })

  description = "An object of ampls settings. If the create_resource property is set to false, the resource will not be created."

  validation {
    condition     = contains(["subnet-lacc-service-common", "subnet-lacc-service-prod"], var.mpls_settings.pe_subnet)
    error_message = "Invalid subnet name. Possible values are subnet-lacc-service-common and subnet-lacc-service-prod."
  }
}
