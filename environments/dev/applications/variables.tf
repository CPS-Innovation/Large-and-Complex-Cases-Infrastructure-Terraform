variable "environment" {
  type        = string
  description = "The name of the environment."
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Invalid input for environment. Valid values are dev, stage and prod."
  }
}

variable "location" {
  type        = string
  description = "The location of the resource group."
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network in which to create the subnet."
}

variable "vnet_rg" {
  type        = string
  description = "The name of the virtual network in which to create the subnet."
}

variable "ado_sc_obj_id" {
  type        = string
  description = "The object ID of the service principal used for deployment with Azure Pipelines."
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.ado_sc_obj_id))
    error_message = "The value given is not in the format of a valid object id."
  }
}

##### ui app #####

variable "ui_spa_always_on" {
  type        = bool
  description = "Should the app be kept warm during periods of inactivity?"
}

variable "app_asp_sku" {
  type        = string
  description = "The SKU of the Linux App Service Plan."
}

variable "app_asp_max_elastic_worker_count" {
  type        = number
  description = "The maximum number of workers that can be used when scaling out the apps on the service plan."
}

variable "app_asp_worker_count" {
  type        = number
  description = "The number of instances running each app on the service plan."
}

##### function apps #####

variable "fa_asp_sku" {
  type        = string
  description = "The SKU of the api function apps' App Service Plan. Valid options are EP1, EP2 and EP3."
  validation {
    condition     = can(regex("^EP[0-9]$", var.fa_asp_sku))
    error_message = "Invalid SKU. Only Elastic Premium plans can be selected. Please choose one of EP1, EP2 and EP3."
  }
}

variable "fa_asp_max_elastic_worker_count" {
  type        = number
  description = "The maximum number of workers that can be used when scaling out the apps on the service plan."
}

variable "fa_asp_worker_count" {
  type        = number
  description = "The number of instances running each app on the service plan. Must be a multiple of availability zones in the region."
}

##### key vault #####

variable "kv_sku" {
  type        = string
  description = "The SKU for the key vault. Valid options are standard and premium."
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
