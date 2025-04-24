variable "environment" {
  type        = string
  description = "The deployment environment"
}

variable "pep_subnet_id" {
  type        = string
  description = "subnet ids that is mapped to the private endpoint"
}

variable "virtual_network_subnet_id" {
  type        = string
  description = "The subnets to map to the app service"
}


variable "name_of_pep" {
  type        = string
  description = "Name of the private end point"
}

variable "subresource_name" {
  type        = list(string)
  description = "subnet ids"
}

variable "private_dns_zone_ids" {
  type        = string
  description = "subnet ids"
}

variable "main_rg" {
  type        = string
  description = "The name of the resource group in which to create the subnet"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "name_of_as" {
  type        = string
  description = "Name of the function App"
}

variable "ui_service_plan_id" {
  type        = string
  description = "Name of the service plan"
}
