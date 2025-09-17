resource "azurerm_service_plan" "linux" {
  #checkov:skip=CKV_AZURE_225:Ensure the App Service Plan is zone redundant
  name                         = "asp-lacc-ui-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  os_type                      = "Linux"
  sku_name                     = var.app_asp_sku
  maximum_elastic_worker_count = var.app_asp_max_elastic_worker_count
  zone_balancing_enabled       = startswith(var.app_asp_sku, "B") ? false : var.app_asp_zone_balancing_enabled
  worker_count                 = var.app_asp_worker_count

  tags = local.tags
}

resource "azurerm_service_plan" "fa_api" {
  name                         = "asp-lacc-api-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  os_type                      = "Windows"
  sku_name                     = var.fa_asp_sku
  maximum_elastic_worker_count = var.fa_asp_max_elastic_worker_count
  zone_balancing_enabled       = true
  worker_count                 = var.fa_asp_worker_count

  tags = local.tags
}
