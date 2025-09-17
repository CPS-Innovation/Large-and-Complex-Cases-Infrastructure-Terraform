# resource "azurerm_linux_web_app" "ui_spa" {
#   #checkov:skip=CKV_AZURE_66:Ensure that App service enables failed request tracing
#   #checkov:skip=CKV_AZURE_88:Ensure that app services use Azure Files
#   #checkov:skip=CKV_AZURE_213:Ensure that App Service configures health check
#   #checkov:skip=CKV_AZURE_13:Ensure App Service Authentication is set on Azure App Service
#   #checkov:skip=CKV_AZURE_17:Ensure the web app has 'Client Certificates (Incoming client certificates)' set
#   name                          = "lacc-app-ui-spa-${var.environment}"
#   location                      = azurerm_resource_group.rg.location
#   service_plan_id               = azurerm_service_plan.linux.id
#   resource_group_name           = azurerm_resource_group.rg.name
#   virtual_network_subnet_id     = data.azurerm_subnet.base["subnet-lacc-linux-apps-${var.environment}"].id
#   public_network_access_enabled = false
#   https_only                    = true

#   site_config {
#     ftps_state              = "FtpsOnly"
#     always_on               = var.ui_spa_always_on
#     http2_enabled           = true
#     app_command_line        = "pm2 serve /home/site/wwwroot/ --no-daemon --spa"
#     minimum_tls_version     = "1.2"
#     managed_pipeline_mode   = "Integrated"
#     scm_minimum_tls_version = "1.2"
#     vnet_route_all_enabled  = true

#     ip_restriction_default_action = "Deny"

#     ip_restriction {
#       action                    = "Allow"
#       headers                   = []
#       name                      = "vnet_integration"
#       priority                  = 110
#       virtual_network_subnet_id = data.azurerm_subnet.base["subnet-lacc-linux-apps-${var.environment}"].id
#     }
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   app_settings = {
#     APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insights.connection_string
#   }

#   logs {
#     detailed_error_messages = true
#     failed_request_tracing  = false

#     http_logs {
#       file_system {
#         retention_in_days = 7
#         retention_in_mb   = 35
#       }
#     }
#   }

#   tags = local.tags

#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
# }

# resource "azurerm_private_endpoint" "pep_ui_web_app" {
#   name                = "pe-${azurerm_linux_web_app.ui_spa.name}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = data.azurerm_subnet.base["subnet-lacc-service-${var.environment}"].id

#   private_service_connection {
#     name                           = azurerm_linux_web_app.ui_spa.name
#     private_connection_resource_id = azurerm_linux_web_app.ui_spa.id
#     subresource_names              = ["sites"]
#     is_manual_connection           = false
#   }

#   private_dns_zone_group {
#     name                 = "app-dns-zone-group"
#     private_dns_zone_ids = [data.azurerm_private_dns_zone.lacc_connectivity["sites"].id]
#   }

#   dynamic "ip_configuration" {
#     for_each = var.ui_spa_pe_ip == null ? [] : [1]
#     content {
#       name               = "ip-${azurerm_linux_web_app.ui_spa.name}"
#       private_ip_address = var.ui_spa_pe_ip
#       subresource_name   = "sites"
#       member_name        = "sites"
#     }
#   }

#   tags = local.tags
# }
