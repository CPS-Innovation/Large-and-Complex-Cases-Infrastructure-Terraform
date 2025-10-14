resource "azurerm_key_vault" "kv_cert" {
  name                = "kv-lacc-cert-${var.environment}"
  resource_group_name = var.devops_rg
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enable_rbac_authorization     = true
  public_network_access_enabled = false
  purge_protection_enabled      = true
  soft_delete_retention_days    = "30"

  network_acls {
    bypass         = "None"
    default_action = "Deny"
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "kv_cert" {
  name                = "pe-${azurerm_key_vault.kv_cert.name}"
  location            = var.location
  resource_group_name = var.devops_rg
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-devops-${var.environment}"].id

  private_service_connection {
    name                           = azurerm_key_vault.kv_cert.name
    private_connection_resource_id = azurerm_key_vault.kv_cert.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["vault"].id]
  }

  tags = local.tags
}
