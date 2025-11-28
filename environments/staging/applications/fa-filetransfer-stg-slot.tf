resource "azurerm_windows_function_app_slot" "filetransfer_stg" {
  name                 = "stg"
  function_app_id      = azurerm_windows_function_app.filetransfer.id
  storage_account_name = azurerm_storage_account.sa.name

  storage_uses_managed_identity = true
  public_network_access_enabled = false
  virtual_network_subnet_id     = data.azurerm_subnet.base["subnet-lacc-windows-apps-${var.environment}"].id
  builtin_logging_enabled       = false
  https_only                    = true

  site_config {
    health_check_path                 = "/api/status"
    health_check_eviction_time_in_min = "10"
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    AzureFunctionsJobHost__extensions__durableTask__hubName = "falaccfiletransferapi${var.environment}stg"
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      tags,
      site_config,
      app_settings
    ]
  }
}

resource "azurerm_private_endpoint" "filetransfer_stg" {
  name                = "pe-fa-lacc-filetransfer-${var.environment}-stg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = "fa-lacc-filetransfer-${var.environment}-stg"
    private_connection_resource_id = azurerm_windows_function_app.filetransfer.id
    subresource_names              = ["sites-stg"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "fa-filetransfer-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["sites"].id]
  }

  tags = local.tags

  depends_on = [azurerm_windows_function_app_slot.filetransfer_stg]
}
