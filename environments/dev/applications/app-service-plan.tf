module "ui-app-service-plan" {
  source = "../../../modules/app-service-plan"

  main_rg        = module.dev-rg.name
  location       = var.location
  environment    = var.environment
  appsrvpln_name = "asp-lacc-ui-${var.environment}"
}

