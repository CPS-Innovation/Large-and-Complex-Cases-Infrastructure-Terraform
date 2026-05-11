resource "azurerm_monitor_action_group" "api_alerts" {
  name                = "ag-lacc-api-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "lacc-api"

  email_receiver {
    name                    = "EmailDevTeam"
    email_address           = var.dev_team_email
    use_common_alert_schema = false
  }
}
