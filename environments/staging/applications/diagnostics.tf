resource "azurerm_monitor_diagnostic_setting" "ai_to_evh_siem" {
  name                           = "ai-to-siem"
  target_resource_id             = azurerm_application_insights.app_insights.id
  eventhub_name                  = "eh-siem-01"
  eventhub_authorization_rule_id = "/subscriptions/9d2e7ffe-ad72-4bfe-ad8f-4932730c0f39/resourceGroups/rg-siem-eventhub/providers/Microsoft.EventHub/namespaces/ns-siem-eventhub/authorizationRules/eh-siem-sap-01"

  dynamic "enabled_log" {
    for_each = ["AppEvents", "AppExceptions", "AppPageViews", "AppRequests", "AppSystemEvents", "AppTraces"]
    content {
      category = enabled_log.value
    }
  }
}
