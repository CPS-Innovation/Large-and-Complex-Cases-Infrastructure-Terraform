data "azurerm_virtual_network" "vnet-lacc" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azurerm_route_table" "lacc-rt" {
  name                = var.rt_lacc_name
  resource_group_name = var.vnet_rg
}

data "azurerm_network_security_group" "nsg" {
  count               = var.create_nsg ? 0 : 1
  name                = "nsg-lacc-${var.subscription_env}"
  resource_group_name = var.vnet_rg
}
