resource "azurerm_monitor_data_collection_rule" "law_transform" {
  name                = "dcr-xform-lacc-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "WorkspaceTransforms"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = azurerm_log_analytics_workspace.law.name
    }
  }

  # filter out logs for the Status health check endpoint
  dynamic "data_flow" {
    for_each = {
      requests = {
        streams       = ["Microsoft-Table-AppRequests"]
        transform_kql = <<-KQL
          source
          | where Name != \"Status\"
        KQL
      }
      traces = {
        streams       = ["Microsoft-Table-AppTraces"]
        transform_kql = <<-KQL
          source
          | where Properties[\"Category\"] != \"Function.Status\"
        KQL
      }
    }
    content {
      streams       = data_flow.value.streams
      destinations  = [azurerm_log_analytics_workspace.law.name]
      transform_kql = data_flow.value.transform_kql
    }
  }

  tags = local.tags
}
