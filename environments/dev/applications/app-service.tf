module "ui-spa" {
  source = "../../../modules/app-service"

  main_rg          = module.dev-rg.name
  location         = module.dev-rg.location
  name_of_fa       = "fa-lacc-${var.environment}"
  name_of_pep      = "fa-lacc-${var.environment}-pep"
  environment      = var.environment
  pep_subnet_id    = data.azurerm_subnet.base["subnet-lacc-service-staging"].id
  subresource_name = ["sites"]

  ui_service_plan_id        = module.ui-app-service-plan.id
  private_dns_zone_ids      = data.azurerm_private_dns_zone.site_laccconnectivity.id
  virtual_network_subnet_id = data.azurerm_subnet.base["subnet-lacc-service-apps-staging"].id
}
