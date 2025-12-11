resource "azurerm_monitor_diagnostic_setting" "ai_to_evh_siem" {
  name                           = "ai-to-siem"
  target_resource_id             = azurerm_application_insights.app_insights.id
  eventhub_name                  = "eh-siem-01"
  eventhub_authorization_rule_id = data.azurerm_eventhub_namespace_authorization_rule.evhns_siem.id

  dynamic "enabled_log" {
    for_each = ["AppEvents", "AppExceptions", "AppPageViews", "AppRequests", "AppSystemEvents", "AppTraces"]
    content {
      category = enabled_log.value
    }
  }

  lifecycle {
    ignore_changes = [metric]
  }
}
