terraform {
  required_version = "1.15.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.4.0"
    }
  }
}

provider "azurerm" {
  features {}
  storage_use_azuread = true
}
