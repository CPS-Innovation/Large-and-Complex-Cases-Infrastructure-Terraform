# import {
#   to = azurerm_windows_function_app_slot.fa_main_slot
#   id = "${azurerm_windows_function_app.fa_main.id}/slots/test-slot"
# }

resource "azurerm_windows_function_app_slot" "fa_main_slot" {
  name                 = "test-slot"
  function_app_id      = azurerm_windows_function_app.fa_main.id
  storage_account_name = azurerm_storage_account.sa.name

  builtin_logging_enabled       = false
  https_only                    = true
  public_network_access_enabled = false
  storage_uses_managed_identity = true
  virtual_network_subnet_id     = data.azurerm_subnet.base["subnet-lacc-windows-apps-${var.environment}"].id

  site_config {}

  lifecycle {
    ignore_changes = [
      app_settings,
      tags,
      site_config,
    ]
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "fa_main_slot" {
  for_each = tomap({
    "Storage Blob Data Owner"        = azurerm_storage_account.sa.id
    "Storage Table Data Contributor" = azurerm_storage_account.sa.id
    "Key Vault Secrets User"         = azurerm_key_vault.kv.id
  })
  scope                = each.value
  role_definition_name = each.key
  principal_id         = azurerm_windows_function_app_slot.fa_main_slot.identity[0].principal_id

  depends_on = [azurerm_windows_function_app_slot.fa_main_slot]
}
