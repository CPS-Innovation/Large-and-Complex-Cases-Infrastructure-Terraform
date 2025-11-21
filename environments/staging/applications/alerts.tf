resource "azurerm_monitor_scheduled_query_rules_alert_v2" "api_5xx" {
  name                = "alert-lacc-api-5xx-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  display_name         = "LACC API ${var.environment} 5xx error"
  description          = "Notify stakeholders of 5xx errors im LCC backend."
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_application_insights.app_insights.id]
  severity             = 2

  criteria {
    query                   = <<-QUERY
      let opId = toscalar(
        requests
        | where resultCode startswith "5"
        | top 1 by timestamp desc
        | project operation_Id
        );
      exceptions
      | where isnotempty(opId) and operation_Id == opId
      | order by timestamp asc
      | take 1
      | extend innermost = tostring(customDimensions["InnermostMessage"])
      | extend msg = coalesce(innermost, tostring(outerMessage), tostring(message))
      | join kind=leftouter (
          requests
          | where operation_Id == opId
          | project
              reqTimestamp = timestamp,
              name,
              method = tostring(customDimensions["RequestMethod"]),
              reqFullname = tostring(customDimensions["FullName"]),
              url,
              resultCode,
              cloud_RoleName,
              operation_Id
          )
          on operation_Id
      | project
          timestamp   = coalesce(timestamp, reqTimestamp),
          reqFullname,
          resultCode,
          method,
          url,
          exType      = type,
          exMessage   = substring(msg, 0, 2048),
          cloud_RoleName,
          operation_Id
      QUERY
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    dynamic "dimension" {
      for_each = ["cloud_RoleName", "exMessage", "exType", "method", "operation_Id", "reqFullname", "resultCode", "url"]
      content {
        name     = dimension.value
        operator = "Include"
        values   = ["*"]
      }
    }

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  enabled                          = true

  action {
    action_groups = [azurerm_monitor_action_group.api_alerts.id]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_monitor_metric_alert" "api_outage" {
  for_each = {
    main-api         = azurerm_windows_function_app.fa_main
    filetransfer-api = azurerm_windows_function_app.filetransfer
  }

  name                = "alert-lacc-${each.key}-outage-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  description         = "No 2xx responses received from ${each.value.name} in 5 minutes. This indicates the service may be down."
  scopes              = [each.value.id]
  severity            = 0

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http 2xx"
    aggregation      = "Minimum"
    operator         = "LessThan"
    threshold        = 1
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.api_alerts.id
  }

  tags = local.tags
}
