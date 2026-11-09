subscription_env = "preprod"

subnets = {
  subnet-lacc-service-staging = {
    address_prefixes   = ["10.14.184.0/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = false
  }
  subnet-lacc-windows-apps-staging = {
    address_prefixes   = ["10.14.184.64/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = true
  }
  subnet-lacc-linux-apps-staging = {
    address_prefixes   = ["10.14.184.32/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = true
  }
}

nsg_rules = {
  AllowAmzWorkspcCustom443Inbound = {
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["10.7.152.0/23", "10.7.150.0/23"]
    destination_address_prefix = "*"
  }
}

private_dns_zones = {
  blob  = "privatelink.blob.core.windows.net"
  table = "privatelink.table.core.windows.net"
  queue = "privatelink.queue.core.windows.net"
  sites = "privatelink.azurewebsites.net"
  vault = "privatelink.vaultcore.azure.net"
}
