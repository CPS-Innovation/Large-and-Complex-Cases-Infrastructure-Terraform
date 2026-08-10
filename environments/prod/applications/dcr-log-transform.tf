# Not using resource reference to the Log Analytics Workspace
# as it creates a dependency cycle when the DCR is referenced
# by the workspace resource attribute data_collection_rule_id

locals {
  law_name        = "log-analytics-lacc-${var.environment}"
  law_resource_id = "${azurerm_resource_group.rg.id}/providers/microsoft.operationalinsights/workspaces/${local.law_name}"
}

resource "azurerm_monitor_data_collection_rule" "law_transform" {
  name                = "dcr-xform-lacc-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "WorkspaceTransforms"

  data_sources {}

  destinations {
    log_analytics {
      workspace_resource_id = local.law_resource_id
      name                  = local.law_name
    }
  }

  # filter out logs for the Status health check endpoint
  dynamic "data_flow" {
    for_each = {
      requests = {
        streams       = ["Microsoft-Table-AppRequests"]
        transform_kql = <<-KQL
          source
          | where Name != "Status"
        KQL
      }
      traces = {
        streams       = ["Microsoft-Table-AppTraces"]
        transform_kql = <<-KQL
          source
          | where Properties["Category"] != "Function.Status"
        KQL
      }
    }
    content {
      streams       = data_flow.value.streams
      destinations  = [local.law_name]
      transform_kql = data_flow.value.transform_kql
    }
  }

  tags = local.tags
}
