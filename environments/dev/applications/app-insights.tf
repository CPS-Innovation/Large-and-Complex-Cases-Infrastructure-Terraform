resource "azurerm_application_insights" "app_insights" {
  name                = "ai-lacc-${var.environment}"
  location            = module.dev-rg.location
  resource_group_name = module.dev-rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.dev.id
}

/* Note: Only select 'Private Only' after adding all Azure Monitor resources to the AMPLS. Traffic to other resources will be
  blocked across networks, subscriptions, and tenants.
  */
resource "azurerm_monitor_private_link_scope" "preprod" {
  name                = "mpls-lacc-preprod"
  resource_group_name = module.dev-rg.name

  ingestion_access_mode = "Open" #"PrivateOnly"
  query_access_mode     = "Open" #"PrivateOnly"
}

resource "azurerm_private_endpoint" "pep_ampls" {
  name                = "mpls-pe-lacc-preprod"
  location            = module.dev-rg.location
  resource_group_name = module.dev-rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-dev"].id

  private_service_connection {
    name                           = "mpls-pe-lacc-preprod-${var.environment}"
    private_connection_resource_id = azurerm_monitor_private_link_scope.preprod.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["azuremonitor"].id]
  }

  tags = local.tags
}

resource "azurerm_log_analytics_workspace" "dev" {
  name                = "log-analytics-lacca-${var.environment}"
  location            = module.dev-rg.location
  resource_group_name = module.dev-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 60
}

resource "azurerm_monitor_private_link_scoped_service" "log_analytics_workspace" {
  name                = "log-analytics-workspace-amplsservice-${var.environment}"
  resource_group_name = module.dev-rg.name #The name of the Azure Monitor Private Link Scope rg. Changing this forces a new resource to be created.
  scope_name          = "mpls-lacc-preprod"
  linked_resource_id  = azurerm_log_analytics_workspace.dev.id

  depends_on = [
    azurerm_log_analytics_workspace.dev
  ]
}

resource "azurerm_monitor_private_link_scoped_service" "application_insights" {
  name                = "ai-amplsservice-${var.environment}"
  resource_group_name = module.dev-rg.name #The name of the Azure Monitor Private Link Scope. Changing this forces a new resource to be created.
  scope_name          = "mpls-lacc-preprod"
  linked_resource_id  = azurerm_application_insights.app_insights.id

  depends_on = [
    azurerm_log_analytics_workspace.dev
  ]
}
