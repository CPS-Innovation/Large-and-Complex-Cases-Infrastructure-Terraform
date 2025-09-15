resource "azurerm_private_dns_zone" "dns" {
  for_each = var.private_dns_zones

  name                = each.value
  resource_group_name = var.vnet_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns" {
  for_each = var.private_dns_zones

  name                  = "dnszonelink-${each.key}"
  resource_group_name   = var.vnet_rg
  private_dns_zone_name = each.value
  virtual_network_id    = data.azurerm_virtual_network.vnet-lacc.id

  depends_on = [azurerm_private_dns_zone.dns]
}
