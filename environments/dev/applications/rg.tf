module "dev-rg" {
  source   = "../../../modules/resource-group"
  name     = "rg-lacc-${var.environment}"
  location = var.location
}

