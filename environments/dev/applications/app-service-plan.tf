module "ui-app-service-plan" {
  source = "../../../modules/app-service-plan"

  rg_name         = module.dev-rg.name
  location        = var.location
  environment     = var.environment
  asp_name        = "asp-lacc-ui-${var.environment}"
}

module "asp-api" {
  source = "../../../modules/app-service-plan"
   
  rg_name         = module.dev-rg.name
  location        = var.location
  environment     = var.environment
  asp_name        = "asp-lacc-api-${var.environment}"
  os_type         = "Windows"
}