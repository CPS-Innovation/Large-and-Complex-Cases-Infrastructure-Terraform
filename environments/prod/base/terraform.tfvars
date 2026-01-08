subscription_env = "prod"
vnet_rg          = "RG-LaCC-Prod-connectivity"
vnet_name        = "VNET-LaCC-Prod-WANNET"
rt_lacc_name     = "rt-lacc-prod"

subnets = {

  subnet-lacc-service-prod = {
    address_prefixes   = ["10.7.185.0/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = false
  }
  subnet-lacc-windows-apps-prod = {
    address_prefixes   = ["10.7.185.32/27"]
    service_endpoints  = ["Microsoft.Storage"]
    service_delegation = true
  }
  subnet-lacc-linux-apps-prod = {
    address_prefixes   = ["10.7.185.64/27"]
    service_endpoints  = ["Microsoft.Storage"]
    service_delegation = true
  }
}

create_nsg = true

nsg_rules = {
  AllowAmzWorkspcCustom443Inbound = {
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.7.152.0/23", "10.7.150.0/23"]
    destination_address_prefix = "*"
  }
  # AllowTagCustom80Outbound = {
  #   priority                   = 110
  #   direction                  = "Outbound"
  #   access                     = "Allow"
  #   protocol                   = "*"
  #   source_port_range          = "*"
  #   destination_port_range     = "80"
  #   source_address_prefix      = "AzureActiveDirectory"
  #   destination_address_prefix = "*"
  # }
}

private_dns_zones = {
  table = "privatelink.table.core.windows.net"
  queue = "privatelink.queue.core.windows.net"
  sites = "privatelink.azurewebsites.net"
  vault = "privatelink.vaultcore.azure.net"
}
