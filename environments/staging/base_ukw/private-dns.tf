locals {
  dns_zone_rg = "RG-LaCC-connectivity"
}

data "azurerm_private_dns_zone" "dns" {
  for_each = var.private_dns_zones

  name                = each.value
  resource_group_name = local.dns_zone_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns" {
  for_each = var.private_dns_zones

  name                  = "dnszonelink-${each.key}-${var.location_shortname}"
  resource_group_name   = local.dns_zone_rg
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.vnet.id

  depends_on = [data.azurerm_private_dns_zone.dns]
}
