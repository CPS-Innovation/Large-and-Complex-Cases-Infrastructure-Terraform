environment  = "preprod"
location     = "UK South"
vnet_rg      = "RG-LaCC-connectivity"
vnet_name    = "VNET-LaCC-WANNET"
rt_lacc_name = "rt-lacc"

subnets = {
  subnet-lacc-service-common = {
    address_prefixes   = ["10.7.184.32/27"]
    service_endpoints  = []
    service_delegation = false
  }
}

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
  AllowTagCustom80Outbound = {
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "AzureActiveDirectory"
    destination_address_prefix = "*"
  }
}
