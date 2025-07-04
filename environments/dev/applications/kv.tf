resource "azurerm_key_vault" "kv" {
  name                = "kv-lacc-${var.environment}"
  resource_group_name = module.dev-rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current
  sku_name            = lower(var.kv_sku)

  enable_rbac_authorization     = true
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
  location            = module.dev-rg.location
  resource_group_name = module.dev-rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = azurerm_key_vault.kv.name
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.vault_lacc_connectivity.id]
  }

  tags = local.tags
}
