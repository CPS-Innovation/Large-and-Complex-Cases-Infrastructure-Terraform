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

resource "azurerm_role_assignment" "kv_secrets_user" {
  for_each = local.fa_principal_ids

  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value
}



locals {
  fa_principal_ids = {
    main         = azurerm_windows_function_app.fa_main.identity[0].principal_id
    filetransfer = azurerm_windows_function_app.filetransfer.identity[0].principal_id
  }

  # # WIP - enable creating all role assignments with a single loop:
  #   role_assignments = {
  #     sa = {
  #       scope = module.sa_dev.id
  #       roles = ["Storage Blob Data Owner", "Storage Table Data Contributor"]
  #       principal_ids = local.fa_principal_ids
  #     },
  #     kv = {
  #       scope = azurerm_key_vault.kv.id
  #       roles = ["Key Vault Secrets User"]
  #       principal_ids = local.fa_principal_ids
  #     }
  #   }

  #   role_assignments_flat = flatten([
  #     for scope_key, scope in role_assignment : {
  #       for id_key, value in item.principal_ids : [
  #         for role in roles : {
  #           scope = item.scope

  #         }
  #       ]
  #     }
  #   ])

}
