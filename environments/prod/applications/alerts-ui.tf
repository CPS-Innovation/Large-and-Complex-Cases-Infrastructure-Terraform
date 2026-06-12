resource "azurerm_monitor_metric_alert" "ui_degraded_health" {
  name                = "alert-lacc-ui-outage-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  description         = "The Health Check results for ${azurerm_linux_web_app.ui_spa.name} indicate degraded instance health."
  scopes              = [azurerm_linux_web_app.ui_spa.id]
  severity            = 1

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HealthCheckStatus"
    aggregation      = "Average"
    operator         = "LessThanOrEqual"
    threshold        = 99
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.ui_alerts.id
  }

  tags = local.tags
}

resource "azurerm_monitor_metric_alert" "ui_5xx_rate" {
  name                = "alert-lacc-ui-5xx-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  description         = "A spike in 5xx response rate from ${azurerm_linux_web_app.ui_spa.name}."
  scopes              = [azurerm_linux_web_app.ui_spa.id]
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = var.alert_ui_5xx_rate_threshold
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.ui_alerts.id
  }

  tags = local.tags
}


resource "azurerm_monitor_metric_alert" "ui_response_time" {
  name                = "alert-lacc-ui-response-time-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  description         = "A spike in response time from ${azurerm_linux_web_app.ui_spa.name}."
  scopes              = [azurerm_linux_web_app.ui_spa.id]
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HttpResponseTime"
    aggregation      = "Maximum"
    operator         = "GreaterThan"
    threshold        = var.alert_ui_latency_threshold
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.ui_alerts.id
  }

  tags = local.tags
}
