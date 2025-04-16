resource "azurerm_linux_web_app" "ui_web_app" {
  name                          = var.name_of_fa
  location                      = var.location
  service_plan_id               = var.ui_service_plan_id
  resource_group_name           = var.main_rg
  virtual_network_subnet_id     = var.virtual_network_subnet_id
  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  site_config {
    http2_enabled          = false
    always_on              = true
    vnet_route_all_enabled = true

    ip_restriction {
      action                    = "Allow"
      headers                   = []
      name                      = "vnet_integration"
      priority                  = 110
      virtual_network_subnet_id = var.virtual_network_subnet_id
    }
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

  lifecycle {
    ignore_changes = all # this needs to be in place to stop the app_setting been replaced as it is set in the pipeline and also to make the application stable. If any
    # changes needs to be made to the application via terraform, change the lifecycle value to [ app_settings ]
  }
}

resource "azurerm_private_endpoint" "pep_queue" {
  name                = var.name_of_pep
  location            = var.location
  resource_group_name = var.main_rg
  subnet_id           = var.pep_subnet_id

  private_service_connection {
    name                           = "lacc-private-service-connect"
    private_connection_resource_id = var.azurerm_storage_account_id
    subresource_names              = var.subresource_name
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "lacc-pri-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_ids]
  }

  tags = {
    environment : var.environment
  }
}
