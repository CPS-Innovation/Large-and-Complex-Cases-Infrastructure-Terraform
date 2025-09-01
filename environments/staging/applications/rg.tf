resource "azurerm_resource_group" "rg" {
  name     = "rg-lacc-${var.environment}"
  location = var.location
}
