locals {
  tags = {
    environment : var.subscription_env
  }

  /*
  The resource references for the following return the correct ID but capitalises the RG name differently,
  i.e. "RG-LaCC-Prod-connectivity" instead of "RG-LaCC-Prod-Connectivity", as is saved in the state file.
  While Azure is case-agnostic, Terraform is case-sensitive and keeps wanting to replace dependent resources unnecessarily.
  */
  virtual_network_id = replace(data.azurerm_virtual_network.vnet-lacc.id, "RG-LaCC-Prod-connectivity", var.vnet_rg)
  nsg_id = replace(
    (var.create_nsg ? azurerm_network_security_group.nsg[0].id : data.azurerm_network_security_group.nsg[0].id),
  "RG-LaCC-Prod-connectivity", var.vnet_rg)
  route_table_id = replace(data.azurerm_route_table.lacc-rt.id, "RG-LaCC-Prod-connectivity", var.vnet_rg)
}
