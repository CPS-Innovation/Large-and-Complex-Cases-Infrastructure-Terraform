resource "azurerm_private_dns_zone" "main" {
  name                = var.private_dns_zones
  resource_group_name = var.vnet_rg
}
