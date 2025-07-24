resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = "${each.key}-${var.environment}"
  resource_group_name  = data.azurerm_virtual_network.vnet-lacc-preprod.resource_group_name # This must be the resource group that the virtual network resides in
  virtual_network_name = data.azurerm_virtual_network.vnet-lacc-preprod.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.service_delegation == true ? [1] : []

    content {
      name = "delegation-${each.key}"

      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_lacc_subnet_assoc" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = data.azurerm_network_security_group.lacc-nsg.id

  depends_on = [azurerm_subnet.subnets]
}

resource "azurerm_subnet_route_table_association" "lacc-rt" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = data.azurerm_route_table.lacc-rt.id

  depends_on = [azurerm_subnet.subnets]

  lifecycle {
    ignore_changes = [route_table_id]
  }
}
