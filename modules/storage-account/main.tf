resource "azurerm_storage_account" "main" {
  name                          = var.name
  resource_group_name           = var.main_rg
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  min_tls_version               = "TLS1_2"
  is_hns_enabled                = true
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_rules" {
    for_each = var.public_network_access_enabled ? [1] : []

    content {
      default_action             = "Deny"
      virtual_network_subnet_ids = var.virtual_network_subnet_ids
      bypass                     = ["Metrics", "AzureServices"]
    }
  }

  tags = {
    environment : var.environment
  }
}

resource "azurerm_private_endpoint" "main" {
  for_each = var.private_endpoints

  name                = "pe-${each.key}-${azurerm_storage_account.main.name}"
  location            = var.location
  resource_group_name = var.main_rg
  subnet_id           = var.pe_subnet_ids

  private_service_connection {
    name                           = "${each.key}-${azurerm_storage_account.main.name}"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = [each.key]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sa-dns-zone-group"
    private_dns_zone_ids = [each.value]
  }

  tags = {
    environment : var.environment
  }
}
