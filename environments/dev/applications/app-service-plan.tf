# module "ui-app-service-plan" {
#   source = "../../../modules/app-service-plan"

#   rg_name     = module.dev-rg.name
#   location    = var.location
#   environment = var.environment
#   asp_name    = "asp-lacc-ui-${var.environment}"
# }

resource "azurerm_service_plan" "app" {
  name                         = "asp-lacc-app-${var.environment}"
  resource_group_name          = module.dev-rg.name
  location                     = var.location
  os_type                      = "Linux"
  sku_name                     = var.app_asp_sku
  maximum_elastic_worker_count = var.app_asp_max_elastic_worker_count
  zone_balancing_enabled       = true
  worker_count                 = var.app_asp_worker_count

  tags = local.tags
}

resource "azurerm_service_plan" "fa_api" {
  name                         = "asp-lacc-api-${var.environment}"
  resource_group_name          = module.dev-rg.name
  location                     = var.location
  os_type                      = "Windows"
  sku_name                     = var.fa_asp_sku
  maximum_elastic_worker_count = var.fa_asp_max_elastic_worker_count
  zone_balancing_enabled       = true
  worker_count                 = var.fa_asp_worker_count

  tags = local.tags
}
