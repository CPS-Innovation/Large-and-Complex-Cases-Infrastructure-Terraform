resource "azurerm_linux_web_app" "ui_spa" {
  name                          = "lacc-app-ui-spa-dev-${var.environment}"
  location                      = module.dev-rg.location
  service_plan_id               = module.ui-app-service-plan.id
  resource_group_name           = module.dev-rg.name
  virtual_network_subnet_id     = data.azurerm_subnet.base["subnet-lacc-service-apps-dev"].id
  public_network_access_enabled = false


  site_config {
    ftps_state              = "FtpsOnly"
    always_on               = true
    http2_enabled           = false
    app_command_line        = "pm2 serve /home/site/wwwroot/ --no-daemon --spa"
    minimum_tls_version     = "1.2"
    managed_pipeline_mode   = "Integrated"
    scm_minimum_tls_version = "1.2"
    vnet_route_all_enabled  = true

    ip_restriction_default_action = "Allow"

    ip_restriction {
      action                    = "Allow"
      headers                   = []
      name                      = "vnet_integration"
      priority                  = 110
      virtual_network_subnet_id = data.azurerm_subnet.base["subnet-lacc-service-apps-dev"].id
    }
  }

  #   app_settings = {
  #     APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.app_insights.instrumentation_key
  #     APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insights.connection_string
  #     app_command_line                      = "pm2 serve /home/site/wwwroot/ --no-daemon --spa"
  #   }

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

  lifecycle {
    ignore_changes = all # this needs to be in place to stop the app_setting been replaced as it is set in the pipeline and also to make the application stable. If any
    # changes needs to be made to the application via terraform, change the lifecycle value to [ app_settings ]
  }
}

resource "azurerm_private_endpoint" "pep_ui_web_app" {
  name                = "lacc-app-ui-spa-dev-${var.environment}-pe"
  location            = module.dev-rg.location
  resource_group_name = module.dev-rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-dev"].id

  private_service_connection {
    name                           = "psc-lacc-app-ui-spa-dev-${var.environment}"
    private_connection_resource_id = azurerm_linux_web_app.ui_spa.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.site_lacc_connectivity.id]
  }

  ip_configuration {
    name               = "lacc-app-ui-spa-dev-static-ip"
    private_ip_address = "10.7.184.101"
    subresource_name   = "sites"
    member_name        = "sites"
  }

  tags = {
    environment : var.environment
  }

  lifecycle {
    ignore_changes = all
  }
}
