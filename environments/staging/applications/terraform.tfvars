environment   = "staging"
location      = "UK South"
vnet_rg       = "RG-LaCC-connectivity"
vnet_name     = "VNET-LaCC-WANNET"
ado_sc_obj_id = "ae888aa2-bc2e-4910-804b-94d4164aed68"

private_dns_zones = {
  blob  = "privatelink.blob.core.windows.net"
  table = "privatelink.table.core.windows.net"
  queue = "privatelink.queue.core.windows.net"
  sites = "privatelink.azurewebsites.net"
  vault = "privatelink.vaultcore.azure.net"
}

ui_spa_always_on               = true
app_asp_sku                    = "P0v3"
app_asp_worker_count           = 1
app_asp_zone_balancing_enabled = false

fa_asp_sku                      = "EP1"
fa_asp_max_elastic_worker_count = 6
fa_asp_worker_count             = 2

kv_sku                      = "standard"
kv_purge_protection_enabled = true

sa_sku         = "Standard"
sa_replication = "LRS"
blob_delete_retention = {
  days                     = 3
  permanent_delete_enabled = true
}
sa_key_access_enabled = false
