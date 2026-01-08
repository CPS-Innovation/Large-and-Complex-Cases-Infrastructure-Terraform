subscription_env = "preprod"
vnet_rg          = "RG-LaCC-connectivity"
vnet_name        = "VNET-LaCC-WANNET"
rt_lacc_name     = "rt-lacc"

subnets = {
  subnet-lacc-service-staging = {
    address_prefixes   = ["10.7.184.0/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = false
  }
  subnet-lacc-windows-apps-staging = {
    address_prefixes   = ["10.7.184.64/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = true
  }
  subnet-lacc-linux-apps-staging = {
    address_prefixes   = ["10.7.184.160/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = true
  }
}

create_nsg = false
