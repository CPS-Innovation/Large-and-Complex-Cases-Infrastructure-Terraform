resource "azurerm_windows_function_app" "fa_main" {
  name                          = "fa-lacc-api-${var.environment}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  storage_account_name          = azurerm_storage_account.sa.name
  storage_uses_managed_identity = true
  service_plan_id               = azurerm_service_plan.fa_api.id
  public_network_access_enabled = false
  virtual_network_subnet_id     = data.azurerm_subnet.base["subnet-lacc-windows-apps-${var.environment}"].id
  builtin_logging_enabled       = false
  https_only                    = true

  site_config {
    vnet_route_all_enabled                 = true
    application_insights_connection_string = azurerm_application_insights.app_insights.connection_string
    elastic_instance_minimum               = 2
    worker_count                           = 2
    app_scale_limit                        = 2
    cors {
      allowed_origins = [
        "https://${azurerm_linux_web_app.ui_spa.default_hostname}",
        "https://login.microsoftonline.com"
      ]
      support_credentials = true
    }

    application_stack {
      dotnet_version              = "v8.0"
      use_dotnet_isolated_runtime = true
    }
  }

  app_settings = {
    FileTransferApiOptions__BaseUrl = "https://${azurerm_windows_function_app.filetransfer.default_hostname}/api/"
  }

  sticky_settings {
    app_setting_names = [
      "FileTransferApiOptions__BaseUrl"
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags


  lifecycle {
    ignore_changes = [
      app_settings,
      tags,
      site_config[0].cors[0].allowed_origins
    ]
    # this needs to be in place to stop the app_setting been replaced as it is set in the pipeline and also to make the application stable. If any
    # changes needs to be made to the application via terraform, change the lifecycle value to [ app_settings ]
  }

  depends_on = [azurerm_storage_account.sa]
}

resource "azurerm_private_endpoint" "pep_fa_main" {
  name                = "pe-fa-lacc-api-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = "fa-lacc-api-${var.environment}"
    private_connection_resource_id = azurerm_windows_function_app.fa_main.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "fa-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["sites"].id]
  }

  tags = local.tags
}
