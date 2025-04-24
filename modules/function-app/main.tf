resource "azurerm_linux_function_app" "main" {
  name                          = var.name_of_fa
  resource_group_name           = var.main_rg
  location                      = var.location
  storage_account_name          = var.storage_account_name
  storage_account_access_key    = var.storage_account_access_key
  service_plan_id               = var.service_plan_id
  public_network_access_enabled = false
  virtual_network_subnet_id     = var.virtual_network_subnet_id
  builtin_logging_enabled       = false
  functions_extension_version   = "~4"


  site_config {
    application_insights_connection_string = var.app_insights_connection_string

    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
  }


  lifecycle {
    ignore_changes = [
      app_settings,
      tags,
    ]
  }
}

resource "azurerm_private_endpoint" "main" {
  name                = var.name_of_pep
  location            = var.location
  resource_group_name = var.main_rg
  subnet_id           = var.pep_subnet_id

  private_service_connection {
    name                           = "lacc-private-service-connect"
    private_connection_resource_id = azurerm_linux_function_app.main.id
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
