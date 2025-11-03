resource "azurerm_logic_app_standard" "logic_alerts" {
  name                       = "logic-alerts-lacc-api-${var.environment}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  app_service_plan_id        = azurerm_service_plan.fa_api.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  virtual_network_subnet_id = data.azurerm_subnet.base["subnet-lacc-windows-apps-${var.environment}"].id

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "logic_alerts" {
  name                = "pe-${azurerm_logic_app_standard.logic_alerts.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = azurerm_logic_app_standard.logic_alerts.name
    private_connection_resource_id = azurerm_logic_app_standard.logic_alerts.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "logic-alerts-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["sites"].id]
  }

  tags = local.tags
}
