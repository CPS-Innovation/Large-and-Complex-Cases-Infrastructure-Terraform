terraform {
  required_version = "1.11.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.23"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
