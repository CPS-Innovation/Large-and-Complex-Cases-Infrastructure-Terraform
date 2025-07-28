module "dev-rg" {
  source   = "../../../modules/resource-group"
  name     = "rg-lacc-${var.environment}"
  location = var.location
}

resource "azurerm_resource_group" "ampls" {
  count = var.mpls_settings.create_resource ? 1 : 0

  name     = "rg-lacc-${var.subscription_env}"
  location = var.location
}
