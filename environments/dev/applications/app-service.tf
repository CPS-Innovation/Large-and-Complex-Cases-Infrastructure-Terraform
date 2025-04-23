module "ui-spa" {
  source = "../../../modules/app-service"

  main_rg          = module.dev-rg.name
  location         = module.dev-rg.location
  name_of_fa       = "var.name_of_fa-${var.environment}"
  name_of_pep      = "var.name_of_fa-${var.environment}-pep"
  environment      = var.environment
  pep_subnet_id    = data.azurerm_subnet.base["subnet-lacc-service-apps-staging"]
  subresource_name = ["sites"]

  ui_service_plan_id         = module.ui-app-service-plan.id
  private_dns_zone_ids       = data.azurerm_private_dns_zone.site_laccconnectivity.id
  virtual_network_subnet_id  = data.azurerm_subnet.base["subnet-lacc-service-apps-staging"].id
  azurerm_storage_account_id = module.sa_dev.id
}
