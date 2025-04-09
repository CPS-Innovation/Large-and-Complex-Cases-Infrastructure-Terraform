# resource "azurerm_resource_group" "staging_rg" {
#   name     = var.staging_rg
#   location = var.location
# }

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = data.azurerm_virtual_network.vnet-lacc-preprod.resource_group_name # This must be the resource group that the virtual network resides on
  virtual_network_name = data.azurerm_virtual_network.vnet-hsk-preprod.name
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

  depends_on = [azurerm_resource_group.staging_rg]
}

resource "azurerm_subnet_network_security_group_association" "nsg_hsk_subnet_assoc" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = data.azurerm_network_security_group.hsk-nsg.id

  depends_on = [azurerm_subnet.subnets]
}

resource "azurerm_subnet_route_table_association" "hsk-rt" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = data.azurerm_route_table.hsk-rt.id

  depends_on = [azurerm_subnet.subnets]
}


import {
  id = "/subscriptions/e4e1767a-3ab8-45ea-8dbd-08fe4961e649/resourceGroups/rg-hsk-connectivity/providers/Microsoft.Network/virtualNetworks/vnet-hsk-preprod/subnets/subnet-hsk-service-common"
  to = azurerm_subnet.subnets["subnet-hsk-service-staging"]
}
