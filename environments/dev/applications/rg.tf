resource "azurerm_resource_group" "rg" {
  name     = "rg-lacc-${var.environment}"
  location = var.location
}


resource "azurerm_resource_group" "reporting" {
  name     = "rg-lacc-reporting-${var.environment}"
  location = var.location
}
