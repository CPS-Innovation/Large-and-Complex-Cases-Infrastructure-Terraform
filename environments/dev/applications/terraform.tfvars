environment      = "dev"
subscription_env = "preprod"
location         = "UK South"
vnet_rg          = "RG-LaCC-connectivity"
vnet_name        = "VNET-LaCC-WANNET"
ado_sc_obj_id    = "ae888aa2-bc2e-4910-804b-94d4164aed68"

private_dns_zones = {
  blob         = "privatelink.blob.core.windows.net"
  table        = "privatelink.table.core.windows.net"
  queue        = "privatelink.queue.core.windows.net"
  sites        = "privatelink.azurewebsites.net"
  azuremonitor = "privatelink.monitor.azure.com"
  vault        = "privatelink.vaultcore.azure.net"
}

ui_spa_always_on     = false
ui_spa_pe_ip         = "10.7.184.101"
app_asp_sku          = "B2"
app_asp_worker_count = 1

fa_asp_sku                      = "EP1"
fa_asp_max_elastic_worker_count = 6
fa_asp_worker_count             = 2

kv_sku                      = "standard"
kv_purge_protection_enabled = false

sa_sku                           = "Standard"
sa_replication                   = "LRS"
sa_public_network_access_enabled = false

mpls_settings = {
  create_resource       = true
  ingestion_access_mode = "Open"
  query_access_mode     = "Open"
  pe_subnet             = "subnet-lacc-service-common"
}
