# Add file storage private DNS zone to enable private networking between logic app and host storage account
resource "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.vnet_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns" {
  name                  = "dnszonelink-file"
  resource_group_name   = var.vnet_rg
  private_dns_zone_name = azurerm_private_dns_zone.file.name
  virtual_network_id    = data.azurerm_virtual_network.vnet-lacc.id
}

# Add storage account to host the logic app
resource "azurerm_storage_account" "logic" {
  name                          = "salacclogic${var.environment}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false
  min_tls_version               = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days                     = 7
      permanent_delete_enabled = false
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  tags = {
    Temporary   = true
    environment = var.environment
    project     = "LACC"
  }
}

resource "azurerm_private_endpoint" "sa_logic" {
  for_each = {
    blob  = data.azurerm_private_dns_zone.lacc_connectivity["blob"].id
    table = data.azurerm_private_dns_zone.lacc_connectivity["table"].id
    queue = data.azurerm_private_dns_zone.lacc_connectivity["queue"].id
    file  = azurerm_private_dns_zone.file.id
  }

  name                = "pe-${each.key}-${azurerm_storage_account.logic.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = "${each.key}-${azurerm_storage_account.logic.name}"
    private_connection_resource_id = azurerm_storage_account.logic.id
    subresource_names              = [each.key]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sa-dns-zone-group"
    private_dns_zone_ids = [each.value]
  }

  tags = {
    Temporary   = true
    environment = var.environment
    project     = "LACC"
  }
}

# Add User-assigned Managed ID to enable RBAC to the host storage account
resource "azurerm_user_assigned_identity" "logic" {
  name                = "id-lacc-logic-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Add logic app service plan + app
resource "azurerm_service_plan" "logic" {
  name                = "asp-lacc-logic-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Windows"
  sku_name = "WS1"

  tags = {
    Temporary   = true
    environment = var.environment
    project     = "LACC"
  }
}

resource "azurerm_logic_app_standard" "reporting" {
  name                       = "logic-lacc-reporting-${var.environment}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_service_plan.logic.id
  storage_account_name       = azurerm_storage_account.logic.name
  storage_account_access_key = azurerm_storage_account.logic.primary_access_key
  storage_account_share_name = "logic-lacc-reporting-${var.environment}"
  virtual_network_subnet_id  = data.azurerm_subnet.base["subnet-lacc-windows-apps-${var.environment}"].id
  vnet_content_share_enabled = true
  public_network_access      = "Disabled"

  site_config {
    vnet_route_all_enabled = true
    http2_enabled          = true
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.logic.principal_id]
  }

  app_settings = {
    "AzureWebJobsStorage__managedIdentityResourceId" = azurerm_user_assigned_identity.logic.id
    "AzureWebJobsStorage__blobServiceUri"            = azurerm_storage_account.logic.primary_blob_endpoint
    "AzureWebJobsStorage__queueServiceUri"           = azurerm_storage_account.logic.primary_queue_endpoint
    "AzureWebJobsStorage__tableServiceUri"           = azurerm_storage_account.logic.primary_table_endpoint
    "AzureWebJobsStorage__credential"                = "managedIdentity"
    "FUNCTIONS_WORKER_RUNTIME"                       = "node"
    "WEBSITE_NODE_DEFAULT_VERSION"                   = "~20"
    "APPLICATIONINSIGHTS_CONNECTION_STRING"          = azurerm_application_insights.app_insights.connection_string
  }

  tags = {
    Temporary   = true
    environment = var.environment
    project     = "LACC"
  }
}

# Add Private endpoint for the logic app
resource "azurerm_private_endpoint" "pe_logic_reporting" {
  name                = "pe-${azurerm_logic_app_standard.reporting.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

  private_service_connection {
    name                           = azurerm_logic_app_standard.reporting.name
    private_connection_resource_id = azurerm_logic_app_standard.reporting.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "logic-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["sites"].id]
  }

  tags = {
    Temporary   = true
    environment = var.environment
    project     = "LACC"
  }
}

# Give logic app access to its host storage account
resource "azurerm_role_assignment" "sa_logic_reporting" {
  for_each = toset([
    "Storage Account Contributor",
    "Storage Blob Data Owner",
    "Storage Queue Data Contributor",
    "Storage Table Data Contributor"
  ])

  role_definition_name = each.value
  scope                = azurerm_storage_account.logic.id
  principal_id         = azurerm_user_assigned_identity.logic.principal_id
}

# Give logic app access to lcc-reports storage container
resource "azurerm_role_assignment" "container_reporting" {
  role_definition_name = "Storage Blob Data Reader"
  scope                = azurerm_storage_container.sa["lcc-reports-${var.environment}"].id
  principal_id         = azurerm_logic_app_standard.reporting.identity[0].principal_id
}
