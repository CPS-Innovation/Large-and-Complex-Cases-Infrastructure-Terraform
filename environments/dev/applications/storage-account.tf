module "sa_dev" {
  source = "../../../modules/storage-account"

  name           = "salacc${var.environment}"
  main_rg        = module.dev-rg.name
  location       = module.dev-rg.location
  pep_subnet_ids = data.azurerm_subnet.base["subnet-lacc-service-dev"].id

  environment = var.environment
  virtual_network_subnet_ids = [
    data.azurerm_subnet.base["subnet-lacc-service-dev"].id,
    data.azurerm_subnet.base["subnet-lacc-devops"].id,
    data.azurerm_subnet.base["subnet-lacc-service-apps-dev"].id
  ]

  /* private endpoint */
  name_of_pep          = "salacc-${var.environment}-pep"
  subresource_name     = ["blob"]
  private_dns_zone_ids = data.azurerm_private_dns_zone.blob_lacc_connectivity.id

}
