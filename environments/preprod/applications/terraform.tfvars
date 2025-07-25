environment = "preprod"
location    = "UK South"
vnet_rg     = "RG-LaCC-connectivity"
vnet_name   = "VNET-LaCC-WANNET"

pe_subnet_name = "subnet-lacc-service-common"

private_dns_zones = {
  #   blob         = "privatelink.blob.core.windows.net"
  #   table        = "privatelink.table.core.windows.net"
  #   queue        = "privatelink.queue.core.windows.net"
  #   sites        = "privatelink.azurewebsites.net"
  azuremonitor = "privatelink.monitor.azure.com"
  #   vault        = "privatelink.vaultcore.azure.net"
}
