resource "azurerm_application_insights" "app_insights" {
  name                = "ai-lacc-${var.environment}"
  location            = module.dev-rg.location
  resource_group_name = module.dev-rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.dev.id
}

resource "azurerm_log_analytics_workspace" "dev" {
  name                = "log-analytics-lacc-${var.environment}"
  location            = module.dev-rg.location
  resource_group_name = module.dev-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 60
}
