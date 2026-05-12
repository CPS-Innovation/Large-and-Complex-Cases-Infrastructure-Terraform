resource "azurerm_monitor_metric_alert" "api_outage" {
  for_each = {
    main-api         = azurerm_windows_function_app.fa_main
    filetransfer-api = azurerm_windows_function_app.filetransfer
  }

  name                = "alert-lacc-${each.key}-outage-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  description         = "No 2xx responses received from ${each.value.name} in 5 minutes. This indicates the service may be down."
  scopes              = [each.value.id]
  severity            = 0

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http2xx"
    aggregation      = "Minimum"
    operator         = "LessThan"
    threshold        = 1
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.api_alerts.id
  }

  tags = local.tags
}


resource "azurerm_monitor_scheduled_query_rules_alert_v2" "api_exceptions" {
  name                = "alert-lacc-api-exceptions-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  display_name         = "LACC API ${var.environment} exception"
  description          = "Notify stakeholders of exceptions in LCC backend."
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_application_insights.app_insights.id]
  severity             = 2

  criteria {
    query = <<-QUERY
      let ExcludedExceptions = dynamic([
        "Invalid token. No authentication token was supplied."
      ]);
      let CrashDetails = exceptions
        | where not(outerMessage has_any(ExcludedExceptions))
        | where severityLevel >= 3
        | extend
            OuterErr = strcat(outerType, ": ", outerMessage),
            InnerErr = strcat(innermostType, ": ", innermostMessage),
            ExUser   = coalesce(tostring(user_Id),
                        tostring(user_AuthenticatedId),
                        tostring(customDimensions.User),
                        tostring(customDimensions.user),
                        tostring(customDimensions.UserId))
        | extend Parsed  = parse_json(details)
        | mv-expand Parsed
        | mv-expand Frame = parse_json(tostring(Parsed.parsedStack))
        | extend StackFrame = strcat(
            "  at ", tostring(Frame.method),
            " in ", tostring(Frame.fileName),
            ":", tostring(Frame.line))
        | summarize
            StackSnippet  = strcat_array(make_list(StackFrame, 5), "\r\n"),
            CrashFunction = tostring(make_list(tostring(Frame.method))[0]),
            CrashFile     = tostring(make_list(tostring(Frame.fileName))[0]),
            CrashLine     = tostring(make_list(tostring(Frame.line))[0]),
            ExUser        = any(ExUser)
            by operation_Id, OuterErr, InnerErr,
              problemId, cloud_RoleName;
        requests
        | join kind=inner (CrashDetails) on operation_Id
        | project
            Timestamp     = tostring(timestamp),
            CloudRole     = tostring(cloud_RoleName),
            Url           = url,
            ResultCode    = resultCode,
            User          = coalesce(tostring(user_Id),
                              tostring(user_AuthenticatedId),
                              ExUser),
            OuterError    = OuterErr,
            InnerError    = InnerErr,
            CrashedAt     = strcat(CrashFunction, " (", CrashFile, ":", CrashLine, ")"),
            ProblemId     = problemId,
            StackSnippet  = StackSnippet
      QUERY

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    dynamic "dimension" {
      for_each = ["Timestamp", "CloudRole", "Url", "ResultCode", "User", "OuterError", "InnerError", "CrashedAt", "ProblemId", "StackSnippet"]
      content {
        name     = dimension.value
        operator = "Include"
        values   = ["*"]
      }
    }

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = true
  workspace_alerts_storage_enabled = false
  enabled                          = true

  action {
    action_groups = [azurerm_monitor_action_group.api_alerts.id]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}
