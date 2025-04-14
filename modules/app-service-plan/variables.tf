variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "appsrvpln_name" {
  type        = string
  description = "The the name of the App Service plan"
}

variable "main_rg" {
  type        = string
  description = "The name of the main resource group"
}

variable "environment" {
  type        = string
  description = "The deployment environment"
}
