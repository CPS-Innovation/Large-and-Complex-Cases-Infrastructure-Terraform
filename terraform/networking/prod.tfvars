environment = {
  name  = "production"
  alias = "prod"
}

terraform_service_principal_display_name = "Azure Pipeline: LaCC-Prod"
subscription_id                          = "[placeholder]"
nsg_name                                 = "[Placeholder]"

appinsights_configuration = {
  log_retention_days                   = 90
  log_total_retention_days             = 2555
  analytics_internet_ingestion_enabled = false
  analytics_internet_query_enabled     = false
  insights_internet_ingestion_enabled  = false
  insights_internet_query_enabled      = false
}


subnets = {
  ampls            = []
  resolverInbound  = []
  resolverOutbound = []
}