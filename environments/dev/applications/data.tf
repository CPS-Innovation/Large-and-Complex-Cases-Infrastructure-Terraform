
data "azurerm_virtual_network" "vnet-lacc-preprod" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

# All subnets of the vnet above.
# To reference a specific subnet use data.azurerm_subnet.base["<subnet-name>"].id

data "azurerm_subnet" "base" {
  for_each = toset(data.azurerm_virtual_network.vnet-lacc-preprod.subnets)

  name                 = each.value
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

# This resource was created outside of terraform because it is required by the statefile storage account which is required for terraform to work
data "azurerm_private_dns_zone" "blob_lacc_connectivity" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.vnet_rg
}

data "azurerm_private_dns_zone" "site_laccconnectivity" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.vnet_rg
}
