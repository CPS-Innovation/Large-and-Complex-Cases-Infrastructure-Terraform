resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-lacc-${var.subscription_env}"
  location            = data.azurerm_virtual_network.vnet-lacc-preprod.location
  resource_group_name = var.vnet_rg

  tags = local.tags
}

resource "azurerm_network_security_rule" "nsg" {
  for_each = var.nsg_rules

  name                         = each.key
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = each.value.source_port_range != null ? each.value.source_port_range : null
  source_port_ranges           = each.value.source_port_range == null ? each.value.source_port_ranges : null
  destination_port_range       = each.value.destination_port_range != null ? each.value.destination_port_range : null
  destination_port_ranges      = each.value.destination_port_range == null ? each.value.destination_port_ranges : null
  source_address_prefix        = each.value.source_address_prefix != null ? each.value.source_address_prefix : null
  source_address_prefixes      = each.value.source_address_prefix == null ? each.value.source_address_prefixes : null
  destination_address_prefix   = each.value.destination_address_prefix != null ? each.value.destination_address_prefix : null
  destination_address_prefixes = each.value.destination_address_prefix == null ? each.value.destination_address_prefixes : null
  resource_group_name          = var.vnet_rg
  network_security_group_name  = azurerm_network_security_group.nsg.name
}
