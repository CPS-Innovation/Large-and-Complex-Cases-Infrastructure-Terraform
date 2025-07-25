/* Note: Only select 'Private Only' after adding all Azure Monitor resources to the MPLS. Traffic to other resources will be
  blocked across networks, subscriptions, and tenants.
  */
resource "azurerm_monitor_private_link_scope" "mpls" {
  name                = "mpls-lacc-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name

  ingestion_access_mode = var.mpls_ingestion_access_mode
  query_access_mode     = var.mpls_query_access_mode
}

resource "azurerm_private_endpoint" "pep_mpls" {
  name                = "mpls-pe-lacc-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base[var.pe_subnet_name].id

  private_service_connection {
    name                           = "pe-mpls-lacc-${var.environment}"
    private_connection_resource_id = azurerm_monitor_private_link_scope.mpls.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["azuremonitor"].id]
  }

  tags = local.tags
}
