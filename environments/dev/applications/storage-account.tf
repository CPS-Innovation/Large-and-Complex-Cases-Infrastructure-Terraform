module "sa_dev" {
  source = "../../../modules/storage-account"

  name          = "salacc${var.environment}"
  main_rg       = module.dev-rg.name
  location      = module.dev-rg.location
  pe_subnet_ids = data.azurerm_subnet.base["subnet-lacc-service-dev"].id

  environment = var.environment

  private_endpoints = {
    blob  = data.azurerm_private_dns_zone.lacc_connectivity["blob"].id
    table = data.azurerm_private_dns_zone.lacc_connectivity["table"].id
    queue = data.azurerm_private_dns_zone.lacc_connectivity["queue"].id
  }
}

# resource "azurerm_storage_share" "ui-spa" {
#   name = "share-${azurerm_linux_web_app.ui_spa.name}"
#   storage_account_id = module.sa_dev.id
#   quota = 50
# }
