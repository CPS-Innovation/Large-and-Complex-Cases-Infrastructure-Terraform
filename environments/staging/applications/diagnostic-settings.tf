resource "azurerm_monitor_diagnostic_setting" "evh_siem" {
  for_each                       = local.diagnostic_settings
  name                           = "${each.key}-to-siem"
  target_resource_id             = each.value.target_resource_id
  eventhub_name                  = "eh-siem-01"
  eventhub_authorization_rule_id = data.azurerm_eventhub_namespace_authorization_rule.evhns_siem.id

  dynamic "enabled_log" {
    for_each = toset(each.value.enabled_logs)
    content {
      category = enabled_log.value
    }
  }

  lifecycle {
    ignore_changes = [metric]
  }
}

locals {
  diagnostic_settings = {
    ai = {
      target_resource_id = azurerm_application_insights.app_insights.id
      enabled_logs       = ["AppEvents", "AppExceptions", "AppPageViews", "AppRequests", "AppSystemEvents", "AppTraces"]
    }
    activity-log = {
      target_resource_id = data.azurerm_client_config.current.subscription_id
      enabled_logs       = ["Administrative", "Policy"]
    }
  }
}
