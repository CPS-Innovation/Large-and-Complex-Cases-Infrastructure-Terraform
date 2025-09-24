subscription_env = "preprod"
vnet_rg          = "RG-LaCC-connectivity"
vnet_name        = "VNET-LaCC-WANNET"
rt_lacc_name     = "rt-lacc"

subnets = {
  subnet-lacc-service-dev = {
    address_prefixes   = ["10.7.184.96/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = false
  }
  subnet-lacc-windows-apps-dev = {
    address_prefixes   = ["10.7.184.128/27"]
    service_endpoints  = ["Microsoft.Storage"]
    service_delegation = true
  }
  subnet-lacc-linux-apps-dev = {
    address_prefixes   = ["10.7.184.192/27"]
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
}
