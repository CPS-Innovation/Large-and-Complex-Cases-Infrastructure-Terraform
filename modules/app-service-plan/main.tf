resource "azurerm_service_plan" "main" {
  name                = var.asp_name
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = title(var.os_type)
  sku_name            = var.sku_name

  tags = {
    environment = var.environment
  }
}
