resource "azurerm_monitor_metric_alert" "kv_throttling" {
  name                = "alert-lacc-kv-throttling-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  description         = "A 429 response was received from the Key Vault service API, indicating that the service is throttling requests."
  scopes              = [azurerm_key_vault.kv_api.id]
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiResult"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "StatusCode"
      operator = "Include"
      values   = ["429"]
    }
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.api_alerts.id
  }

  tags = local.tags
}

resource "azurerm_monitor_metric_alert" "blob_service_delete_ops" {
  name                = "alert-lacc-blob-delete-ops-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  description         = "A blob or container was deleted from storage account salacc${var.environment}."
  scopes              = [azurerm_storage_account.sa.id]
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts/blobServices"
    metric_name      = "Transactions"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0

    dynamic "dimension" {
      for_each = toset(["DeleteBlob", "DeleteContainer", "DeleteFile"])
      content {
        name     = "ApiName"
        operator = "Include"
        values   = [dimension.value]
      }
    }
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.api_alerts.id
  }

  tags = local.tags
}
