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
  retention_in_days          = var.log_retention_days
  internet_ingestion_enabled = false
  internet_query_enabled     = false

  # Not using resource reference to the DCR as this creates a dependency cycle
  data_collection_rule_id = "${azurerm_resource_group.rg.id}/providers/Microsoft.Insights/dataCollectionRules/dcr-xform-lacc-${var.environment}"
}
