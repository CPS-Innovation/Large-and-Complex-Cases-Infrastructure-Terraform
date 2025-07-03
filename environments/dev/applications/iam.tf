resource "azurerm_role_assignment" "filetransfer_sa" {
  for_each = var.fa_sa_roles

  scope                = module.sa_dev.id
  role_definition_name = each.value
  principal_id         = azurerm_windows_function_app.filetransfer.identity[0].principal_id
}

resource "azurerm_role_assignment" "fa_main_sa" {
  for_each = var.fa_sa_roles

  scope                = module.sa_dev.id
  role_definition_name = each.value
  principal_id         = azurerm_windows_function_app.fa_main.identity[0].principal_id
}
