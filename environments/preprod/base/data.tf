data "azurerm_virtual_network" "vnet-lacc-preprod" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azurerm_route_table" "lacc-rt" {
  name                = var.rt_lacc_name
  resource_group_name = var.vnet_rg
}
