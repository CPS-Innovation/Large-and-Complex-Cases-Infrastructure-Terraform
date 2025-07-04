location                        = "UK South"
environment                     = "dev"
vnet_rg                         = "RG-LaCC-connectivity"
vnet_name                       = "VNET-LaCC-WANNET"
fa_sa_roles                     = ["Storage Blob Data Owner", "Storage Table Data Contributor"]
fa_asp_sku                      = "EP1"
fa_asp_max_elastic_worker_count = 6
fa_asp_worker_count             = 3
