resource "azurerm_linux_web_app_slot" "ui_spa_stg" {
  name           = "lacc-app-ui-spa-${var.environment}"
  app_service_id = azurerm_linux_web_app.ui_spa.id

  virtual_network_subnet_id     = data.azurerm_subnet.base["subnet-lacc-linux-apps-${var.environment}"].id
  public_network_access_enabled = false
  https_only                    = true

  site_config {}

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insights.connection_string
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = false

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "ui_spa_stg" {
  name                = "pe-${azurerm_linux_web_app.ui_spa.name}-stg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = "${azurerm_linux_web_app.ui_spa.name}-stg"
    private_connection_resource_id = azurerm_linux_web_app_slot.ui_spa_stg.id
    subresource_names              = ["sites-stg"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "app-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["sites"].id]
  }

  tags = local.tags
}
