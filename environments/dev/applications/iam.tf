resource "azurerm_role_assignment" "sa" {
  for_each = tomap({
    for role_assignment in local.sa_roles : "${role_assignment.role}.${role_assignment.principal_name}" => role_assignment
  })

  scope                = module.sa_dev.id
  role_definition_name = each.value.role
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "kv" {
  for_each = tomap({
    for role_assignment in local.kv_roles : "${role_assignment.role}.${role_assignment.principal_name}" => role_assignment
  })

  scope                = azurerm_key_vault.kv.id
  role_definition_name = each.value.role
  principal_id         = each.value.principal_id
}


# locals {

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

# }
