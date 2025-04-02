environment = {
  name  = "test"
  alias = "test"
}

terraform_service_principal_display_name = "Azure Pipeline: LaCC-PreProd"
dns_server                               = "10.7.184.196"
dns_alt_server                           = "168.63.129.16"
subscription_id                          = "7f67e716-03c5-4675-bad2-cc5e28652759"

service_plans = {
  ui_service_plan_sku   = "P1v3"
  ui_worker_count       = 3
  api_service_plan_sku  = "P1v3"
  api_worker_count      = 3
  mock_service_plan_sku = "P0v3"
  mock_worker_count     = 3
}

service_capacity = {
  ui_default_capacity   = 1
  ui_minimum_capacity   = 1
  ui_max_capacity       = 3
  api_default_capacity  = 1
  api_minimum_capacity  = 1
  api_max_capacity      = 1
  mock_default_capacity = 1
  mock_minimum_capacity = 1
  mock_max_capacity     = 3
}

subnets = {
  storage     = []
  ui          = []
  api         = []
  endpoints   = []
  mock        = []
  buildAgents = []
}