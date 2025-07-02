variable "location" {
  type        = string
  description = "The location of the ASP resource"
}

variable "asp_name" {
  type        = string
  description = "The the name of the ASP"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group where the ASP is created"
}

variable "environment" {
  type        = string
  description = "The deployment environment"
}

variable "os_type" {
  type = string
  description = "The OS of the ASP, e.g. 'Linux' or 'Windows'"
  default = "Linux"
}

variable "sku_name" {
  type = string
  description = "The SKU of the ASP"
  default = "B2"
}