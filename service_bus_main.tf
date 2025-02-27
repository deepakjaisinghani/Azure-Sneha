resource "azurerm_monitor_metric_alert" "SBPremium-CPUUtilization" {
  name        = "${var.region}-${var.env}-SBPremium-${var.sb-premium}-CPUUtilization"
  description = "${var.region}-${var.env}-SBPremium-${var.sb-premium}-CPUUtilization | ${var.region}-${var.env}"

  resource_group_name = var.resource_group
  scopes              = ["/subscriptions/${var.sub}/resourceGroups/${var.rg-sb-premium}/providers/Microsoft.ServiceBus/namespaces/${var.sb-premium}"]
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.ServiceBus/namespaces"
    metric_name      = "NamespaceCpuUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.sb-premium-cpu
  }
  tags = { "type" = "terraform_module" }
  action {
    action_group_id = var.action_group
  }
}

resource "azurerm_monitor_metric_alert" "SBPremium-MemoryUtilization" {
  name        = "${var.region}-${var.env}-SBPremium-${var.sb-premium}-MemoryUtilization"
  description = "${var.region}-${var.env}-SBPremium-${var.sb-premium}-MemoryUtilization | ${var.region}-${var.env}"

  resource_group_name = var.resource_group
  scopes              = ["/subscriptions/${var.sub}/resourceGroups/${var.rg-sb-premium}/providers/Microsoft.ServiceBus/namespaces/${var.sb-premium}"]
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.ServiceBus/namespaces"
    metric_name      = "NamespaceMemoryUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.sb-premium-mem
  }
  tags = { "type" = "terraform_module" }
  action {
    action_group_id = var.action_group
  }
}

resource "azurerm_monitor_metric_alert" "SBPremium-ActiveMsgCount" {
  for_each    = var.ServiceBus
  name        = "${var.region}-${var.env}-SBPremium-${each.key}-ActiveMsgCount"
  description = "${var.region}-${var.env}-SBPremium-${each.key}-ActiveMsgCount | ${var.region}-${var.env}"

  resource_group_name = var.resource_group
  scopes              = ["/subscriptions/${var.sub}/resourceGroups/${var.rg-sb-premium}/providers/Microsoft.ServiceBus/namespaces/${var.sb-premium}"]
  severity            = 1
  enabled             = each.value.enable
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.ServiceBus/namespaces"
    metric_name      = "ActiveMessages"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = each.value.threshold-activemsg

    dimension {
      name     = "EntityName"
      operator = "Include"
      values   = each.value.values
    }
  }
  tags = { "type" = "terraform_module" }
  action {
    action_group_id = var.env == "UAT" ? var.action_group : each.value.action_group
  }
}

resource "azurerm_monitor_metric_alert" "SBPremium-DlqCount" {
  for_each    = var.ServiceBus
  name        = "${var.region}-${var.env}-SBPremium-${each.key}-DlqCount"
  description = each.key == "BetFundTransfer" ? "${var.region}-${var.env}-SBPremium-${each.key}-DlqCount | If betpayoutcommands-betfundstransferengine, then use https://pointsbet.atlassian.net/wiki/spaces/SRE/pages/2511765505/BetFundTransferEngine+DLQ+Runbook | ${var.region}-${var.env}" : "${var.region}-${var.env}-SBPremium-${each.key}-DlqCount"

  resource_group_name = var.resource_group
  scopes              = ["/subscriptions/${var.sub}/resourceGroups/${var.rg-sb-premium}/providers/Microsoft.ServiceBus/namespaces/${var.sb-premium}"]
  severity            = 1
  enabled             = each.value.enable
  auto_mitigate       = false
  frequency           = "PT1M"
  window_size         = "PT1M"

  criteria {
    metric_namespace = "Microsoft.ServiceBus/namespaces"
    metric_name      = "DeadletteredMessages"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = each.value.threshold-dlq

    dimension {
      name     = "EntityName"
      operator = "Include"
      values   = each.value.values
    }
  }
  tags = { "type" = "terraform_module" }
  action {
    action_group_id = var.env == "UAT" ? var.action_group : each.value.action_group
  }
}
