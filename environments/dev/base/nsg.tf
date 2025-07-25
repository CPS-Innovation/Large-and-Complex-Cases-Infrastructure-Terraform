resource "azurerm_network_security_group" "nsg" {
  count = var.create_nsg ? 1 : 0

  name                = "nsg-lacc-${var.subscription_env}"
  location            = data.azurerm_virtual_network.vnet-lacc-preprod.location
  resource_group_name = var.vnet_rg

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                         = security_rule.key
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range != null ? security_rule.value.source_port_range : null
      source_port_ranges           = security_rule.value.source_port_range == null ? security_rule.value.source_port_ranges : null
      destination_port_range       = security_rule.value.destination_port_range != null ? security_rule.value.destination_port_range : null
      destination_port_ranges      = security_rule.value.destination_port_range == null ? security_rule.value.destination_port_ranges : null
      source_address_prefix        = security_rule.value.source_address_prefix != null ? security_rule.value.source_address_prefix : null
      source_address_prefixes      = security_rule.value.source_address_prefix == null ? security_rule.value.source_address_prefixes : null
      destination_address_prefix   = security_rule.value.destination_address_prefix != null ? security_rule.value.destination_address_prefix : null
      destination_address_prefixes = security_rule.value.destination_address_prefix == null ? each.value.destination_address_prefixes : null
    }
  }

  tags = local.tags
}
