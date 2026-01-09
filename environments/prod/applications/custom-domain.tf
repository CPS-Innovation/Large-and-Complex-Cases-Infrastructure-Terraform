locals {
  custom_hostnames = {
    lcc = {
      app_service     = azurerm_linux_web_app.ui_spa
      functional_area = "ui"
    }
    lcc-api = {
      app_service     = azurerm_windows_function_app.fa_main
      functional_area = "api"
    }
  }
}

data "azurerm_app_service_certificate" "cert" {
  for_each = local.custom_hostnames

  name                = "cert-lacc-${each.value.functional_area}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_app_service_custom_hostname_binding" "hostname" {
  for_each            = local.custom_hostnames
  hostname            = "www.${each.key}.cps.gov.uk"
  app_service_name    = each.value.app_service.name
  resource_group_name = azurerm_resource_group.rg.name

  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_certificate_binding" "hostname" {
  for_each            = local.custom_hostnames
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname[each.key].id
  certificate_id      = data.azurerm_app_service_certificate.cert[each.key].id
  ssl_state           = "SniEnabled"
}
