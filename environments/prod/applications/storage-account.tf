resource "azurerm_storage_account" "sa" {
  #checkov:skip=CKV_AZURE_33:Ensure Storage logging is enabled for Queue service for read, write and delete requests
  #checkov:skip=CKV2_AZURE_1:Ensure storage for critical data are encrypted with Customer Managed Key
  #checkov:skip=CKV_AZURE_206:Ensure that Storage Accounts use replication
  name                            = "salacc${var.environment}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  account_tier                    = title(var.sa_sku)
  account_replication_type        = var.sa_replication
  min_tls_version                 = "TLS1_2"
  is_hns_enabled                  = true
  public_network_access_enabled   = false
  shared_access_key_enabled       = var.sa_key_access_enabled
  allow_nested_items_to_be_public = false
  local_user_enabled              = false

  blob_properties {
    delete_retention_policy {
      days                     = var.blob_delete_retention.days
      permanent_delete_enabled = var.blob_delete_retention.permanent_delete_enabled
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
