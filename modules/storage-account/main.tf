resource "azurerm_storage_account" "main" {
  name                     = var.name
  resource_group_name      = var.main_rg
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  is_hns_enabled            = true

  network_rules {
    default_action = "Deny"
    virtual_network_subnet_ids = var.virtual_network_subnet_ids 
  }

  tags = {
    environment : var.environment
  }
}

resource "azurerm_private_endpoint" "pep_queue" {
  name                = var.name_of_pep
  location            = var.location
  resource_group_name = var.main_rg
  subnet_id           = var.subnet_ids

  private_service_connection {
    name                           = "lacc-private-service-connect"
    private_connection_resource_id = var.pcr_id
    subresource_names              = [var.subresource_name]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "lacc-pri-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_ids]
  }

  tags = {
    environment : var.environment
  }
}