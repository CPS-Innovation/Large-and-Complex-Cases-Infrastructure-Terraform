resource "azurerm_storage_account" "sa" {
  name                          = "salacc${var.environment}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  account_tier                  = title(var.sa_sku)
  account_replication_type      = var.sa_replication
  min_tls_version               = "TLS1_2"
  is_hns_enabled                = true
  public_network_access_enabled = var.sa_public_network_access_enabled

  dynamic "network_rules" {
    for_each = var.sa_public_network_access_enabled ? [1] : []

    content {
      default_action = "Deny"
      virtual_network_subnet_ids = [
        data.azurerm_subnet.base["subnet-lacc-windows-apps-${var.environment}"].id,
        data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id,
        data.azurerm_subnet.base["subnet-lacc-devops"].id
      ]
      bypass = ["Metrics", "AzureServices"]
    }
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "sa" {
  for_each = {
    blob  = data.azurerm_private_dns_zone.lacc_connectivity["blob"].id
    table = data.azurerm_private_dns_zone.lacc_connectivity["table"].id
    queue = data.azurerm_private_dns_zone.lacc_connectivity["queue"].id
  }

  name                = "pe-${each.key}-${azurerm_storage_account.sa.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = "${each.key}-${azurerm_storage_account.sa.name}"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = [each.key]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sa-dns-zone-group"
    private_dns_zone_ids = [each.value]
  }

  tags = local.tags
}
