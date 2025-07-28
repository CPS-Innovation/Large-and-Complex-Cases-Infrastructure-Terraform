/* Note: Only select 'Private Only' after adding all Azure Monitor resources to the MPLS. Traffic to other resources will be
  blocked across networks, subscriptions, and tenants.
  */
resource "azurerm_monitor_private_link_scope" "mpls" {
  count = var.mpls_settings.create_resource ? 1 : 0

  name                = "mpls-lacc-${var.subscription_env}"
  resource_group_name = var.environment == var.subscription_env ? azurerm_resource_group.rg.name : azurerm_resource_group.ampls[0].name

  ingestion_access_mode = var.mpls_settings.ingestion_access_mode
  query_access_mode     = var.mpls_settings.query_access_mode
}

resource "azurerm_private_endpoint" "pep_mpls" {
  count = var.mpls_settings.create_resource ? 1 : 0

  name                = "pe-${azurerm_monitor_private_link_scope.mpls[0].name}"
  location            = var.location
  resource_group_name = var.environment == var.subscription_env ? azurerm_resource_group.rg.name : azurerm_resource_group.ampls[0].name
  subnet_id           = data.azurerm_subnet.base[var.mpls_settings.pe_subnet].id

  private_service_connection {
    name                           = azurerm_monitor_private_link_scope.mpls[0].name
    private_connection_resource_id = azurerm_monitor_private_link_scope.mpls[0].id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "mpls-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["azuremonitor"].id]
  }

  tags = local.tags
}
