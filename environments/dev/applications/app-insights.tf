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

resource "azurerm_monitor_private_link_scoped_service" "law" {
  name                = "law-mplsservice-${var.environment}"
  resource_group_name = "rg-lacc-${var.subscription_env}"
  scope_name          = "mpls-lacc-${var.subscription_env}"
  linked_resource_id  = azurerm_log_analytics_workspace.law.id

  depends_on = [
    azurerm_log_analytics_workspace.law
  ]
}

resource "azurerm_monitor_private_link_scoped_service" "application_insights" {
  name                = "ai-mplsservice-${var.environment}"
  resource_group_name = "rg-lacc-${var.subscription_env}"
  scope_name          = "mpls-lacc-${var.subscription_env}"
  linked_resource_id  = azurerm_application_insights.app_insights.id

  depends_on = [
    azurerm_log_analytics_workspace.law
  ]
}
