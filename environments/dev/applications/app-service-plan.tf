resource "azurerm_service_plan" "linux" {
  name                         = "asp-lacc-ui-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  os_type                      = "Linux"
  sku_name                     = var.app_asp_sku
  maximum_elastic_worker_count = var.app_asp_max_elastic_worker_count
  zone_balancing_enabled       = false
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
