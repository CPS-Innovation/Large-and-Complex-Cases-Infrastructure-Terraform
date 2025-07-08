vnet_rg       = "RG-LaCC-connectivity"
vnet_name     = "VNET-LaCC-WANNET"
rt_lacc_name  = "rt-lacc"
nsg_lacc_name = "nsg-lacc-dev"
subnets = {
  subnet-lacc-service-dev = {
    address_prefixes   = ["10.7.184.96/27"]
    service_endpoints  = ["Microsoft.Storage", "Microsoft.KeyVault"]
    service_delegation = false
  }
  subnet-lacc-service-api-dev = {
    address_prefixes   = ["10.7.184.128/27"]
    service_endpoints  = ["Microsoft.Storage"]
    service_delegation = true
  }
  #  TODO:  If keeping separate subnets for ui and api: rename 'apps' to 'ui'
  #         If using MPSJ, subnets will need reshuffling to make space for one /26 large subnet
  subnet-lacc-service-apps-dev = {
    address_prefixes   = ["10.7.184.192/27"]
    service_endpoints  = ["Microsoft.Storage"]
    service_delegation = true
  }
  subnet-lacc-service-common-dev = {
    address_prefixes   = ["10.7.184.248/29"]
    service_endpoints  = ["Microsoft.Storage"]
    service_delegation = true
  }
}
