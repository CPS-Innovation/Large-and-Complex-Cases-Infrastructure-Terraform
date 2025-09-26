resource "azurerm_key_vault" "kv" {
  name                = "kv-lacc-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = lower(var.kv_sku)

  rbac_authorization_enabled    = true
  public_network_access_enabled = false
  purge_protection_enabled      = var.kv_purge_protection_enabled
  soft_delete_retention_days    = "7"

  network_acls {
    bypass         = "None"
    default_action = "Deny"
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "kv" {
  name                = "pe-${azurerm_key_vault.kv.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = azurerm_key_vault.kv.name
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["vault"].id]
  }

  tags = local.tags
}
