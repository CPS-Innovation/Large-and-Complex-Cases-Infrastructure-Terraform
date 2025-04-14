resource "azurerm_service_plan" "main" {
  name                = var.appsrvpln_name
  resource_group_name = var.main_rg
  location            = var.location
  os_type             = "Linux"

  sku_name = "B2"

  tags = {
    environment = var.environment
  }
}
