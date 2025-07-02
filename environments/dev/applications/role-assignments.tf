resource "azurerm_role_assignment" "filetransfer_st_blob_data_owner" {
  scope                = module.sa_dev.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_windows_function_app.filetransfer.identity[0].principal_id
}

resource "azurerm_role_assignment" "filetransfer_st_table_data_cont" {
  scope                = module.sa_dev.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_windows_function_app.filetransfer.identity[0].principal_id
}
