output "subnet_id" {
  value = {
    for k, v in azurerm_subnet.subnets :
    k => v.id
  }
}


output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet-lacc.id
}
