locals {
  tags = {
    environment : var.environment
  }

  fa_principal_ids = {
    main         = azurerm_windows_function_app.fa_main.identity[0].principal_id
    filetransfer = azurerm_windows_function_app.filetransfer.identity[0].principal_id
  }
}
