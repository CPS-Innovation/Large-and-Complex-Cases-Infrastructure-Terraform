environment   = "dev"
location      = "UK South"
vnet_name     = "VNET-LaCC-WANNET"
vnet_rg       = "RG-LaCC-connectivity"
ado_sc_obj_id = "ae888aa2-bc2e-4910-804b-94d4164aed68"

ui_spa_always_on                 = false
app_asp_sku                      = "B2"
app_asp_max_elastic_worker_count = 2
app_asp_worker_count             = 1

fa_asp_sku                      = "EP1"
fa_asp_max_elastic_worker_count = 6
fa_asp_worker_count             = 2

kv_sku                      = "standard"
kv_purge_protection_enabled = false

sa_sku                           = "Standard"
sa_replication                   = "LRS"
sa_public_network_access_enabled = false
