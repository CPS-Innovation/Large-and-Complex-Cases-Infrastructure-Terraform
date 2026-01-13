resource "azurerm_application_insights" "app_insights" {
  name                       = "ai-lacc-${var.environment}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  application_type           = "web"
  workspace_id               = azurerm_log_analytics_workspace.law.id
  internet_ingestion_enabled = false
  internet_query_enabled     = false
}

resource "azurerm_log_analytics_workspace" "law" {
  name                       = "log-analytics-lacc-${var.environment}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  sku                        = "PerGB2018"
  retention_in_days          = 60
  internet_ingestion_enabled = false
  internet_query_enabled     = false
}

resource "azurerm_application_insights" "reporting" {
  name                       = "ai-lacc-reporting-${var.environment}"
  location                   = azurerm_resource_group.reporting.location
  resource_group_name        = azurerm_resource_group.reporting.name
  application_type           = "web"
  workspace_id               = azurerm_log_analytics_workspace.law.id
  internet_ingestion_enabled = false
  internet_query_enabled     = false
}
