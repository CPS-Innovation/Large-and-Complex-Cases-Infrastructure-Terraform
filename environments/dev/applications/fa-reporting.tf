resource "azurerm_windows_function_app" "reporting" {
  name                          = "fa-lacc-reporting-api-${var.environment}"
  resource_group_name           = azurerm_resource_group.reporting.name
  location                      = azurerm_resource_group.reporting.location
  storage_account_name          = azurerm_storage_account.sa.name
  storage_uses_managed_identity = true
  service_plan_id               = azurerm_service_plan.fa_api.id
  public_network_access_enabled = false
  virtual_network_subnet_id     = data.azurerm_subnet.base["subnet-lacc-windows-apps-${var.environment}"].id
  builtin_logging_enabled       = false
  https_only                    = true

  site_config {
    application_insights_connection_string = azurerm_application_insights.reporting.connection_string
    vnet_route_all_enabled                 = true
    cors {
      allowed_origins = [
        "https://${azurerm_linux_web_app.ui_spa.default_hostname}",
        "https://portal.azure.com",
      ]
      support_credentials = true
    }

    application_stack {
      dotnet_version              = "v8.0"
      use_dotnet_isolated_runtime = true
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      tags,
      app_settings
    ]
  }

  depends_on = [azurerm_storage_account.sa]
}

resource "azurerm_private_endpoint" "pep_fa_reporting" {
  name                = "pe-${azurerm_windows_function_app.reporting.name}"
  location            = azurerm_resource_group.reporting.location
  resource_group_name = azurerm_resource_group.reporting.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = azurerm_windows_function_app.reporting.name
    private_connection_resource_id = azurerm_windows_function_app.reporting.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "fa-reporting-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["sites"].id]
  }

  tags = local.tags
}
