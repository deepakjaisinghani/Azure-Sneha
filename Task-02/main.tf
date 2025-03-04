module "azure_action_group" {
  # This will create Azure Alerts Action Group and Alerts
  source         = "./modules/azure_resources/action_group"
  resource_group = azurerm_resource_group.rg_alerts.name
  region         = var.region
  env            = var.env
  action_groups  = var.action_groups
}
module "app_insights_common" {
  # This will create app insight alerts that are common to all regions.
  source         = "./modules/azure_resources/app_insights"
  app_insights   = local.app_insights_common
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}
module "app_insights_au" {
  count          = var.region == "AU" ? 1 : 0
  source         = "./modules/azure_resources/app_insights"
  app_insights   = local.app_insights_au
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

module "app_insights_on" {
  count          = var.region == "ON" ? 1 : 0
  source         = "./modules/azure_resources/app_insights"
  app_insights   = local.app_insights_on
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

module "microfrontend_businessfunc" {
  source         = "./modules/azure_resources/microfrontend_businessfunc"
  business_funcs = local.microfrontend_businessfunc
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

module "eventhub" {
  # Alerts for eventhub that are in AU region.
  source         = "./modules/azure_resources/eventhub"
  count          = var.region == "AU" ? 1 : 0
  eventhub       = local.eventhub_au
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

# 
# servicebus
# 
module "servicebus_common" {
  # Alerts for Service Bus that are common to all region.
  source         = "./modules/azure_resources/servicebus"
  count          = (var.env == "PROD" || var.env == "UAT") ? 1 : 0
  ServiceBus     = local.servicebus_common
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
  rg-sb-premium  = var.rg-sb-premium == "" ? "rg-premiumsb-${var.region}-${var.env}" : var.rg-sb-premium
  sb-premium     = var.sb-premium == "" ? "sb-premium-${var.region}-${var.env}" : var.sb-premium
  sb-premium-cpu = var.region == "ON" ? var.sb-premium-cpu-on : var.sb-premium-cpu
  sb-premium-mem = var.sb-premium-mem
}

module "servicebus_au" {
  # Alerts for Service Bus that are in au only.
  source         = "./modules/azure_resources/servicebus"
  count          = var.region == "AU" ? 1 : 0
  ServiceBus     = local.servicebus_au
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
  rg-sb-premium  = var.rg-sb-premium == "" ? "rg-premiumsb-${var.region}-${var.env}" : var.rg-sb-premium
  sb-premium     = var.sb-premium == "" ? "sb-premium-${var.region}-${var.env}" : var.sb-premium
  sb-premium-cpu = var.sb-premium-cpu
  sb-premium-mem = var.sb-premium-mem
}

# 
# cosmos
# 
module "cosmos_common" {
  # ALerts for Cosmos DB that are common to all region.
  source         = "./modules/azure_resources/cosmos"
  cosmos         = local.cosmos_common
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

module "cosmos_au" {
  # Alerts for Cosmos DB that are in au region only.
  source         = "./modules/azure_resources/cosmos"
  count          = var.region == "AU" ? 1 : 0
  cosmos         = local.cosmos_au
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

module "cosmos_casino" {
  source         = "./modules/azure_resources/cosmos"
  count          = var.region == "ON" ? 1 : 0
  cosmos         = local.cosmos_casino
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

# 
# redis
# 
module "redis_mes" {
  # Alerts for Redis that are common to all regions.
  source         = "./modules/azure_resources/redis"
  redis          = local.redis_mes
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

# 
# VM
# 
#module "vm_rabbitmq" {
#  source          = "./modules/azure_resources/virtual_machine"
#  virtual_machine = local.vm_rabbitmq
#  action_group    = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
#  resource_group  = azurerm_resource_group.rg_alerts.name
#  env             = var.env
#  region          = var.region
#  sub             = var.sub
#}

#
# domain controller
#
module "vm_dc" {
  source          = "./modules/azure_resources/virtual_machine"
  count           = var.env == "PROD" ? 1 : 0
  virtual_machine = local.vm_dc
  action_group    = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group  = azurerm_resource_group.rg_alerts.name
  env             = var.env
  region          = var.region
  sub             = var.sub
}

# 
# signalr
# 
module "signalr" {
  # Alert for signalr service.
  source         = "./modules/azure_resources/signalr"
  signalr        = local.signalr
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}


# 
# apim
# 
module "apim_common" {
  # Alerts for api management service.
  source                 = "./modules/azure_resources/apim"
  count                  = var.env == "PROD" ? 1 : 0
  api_management_service = local.apim_commom
  action_group           = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group         = azurerm_resource_group.rg_alerts.name
  env                    = var.env
  region                 = var.region
  sub                    = var.sub
  apim-capacity          = var.apim-capacity
}

# 
# firewall
# 
module "firewall" {
  # Alerts for firewall service.
  count          = var.env == "PROD" ? 1 : 0
  source         = "./modules/azure_resources/firewall"
  firewall       = local.firewall
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}


# 
# loadbalancer
# 

module "loadbalancer" {
  # Alerts for loadbalancer that are common to all region.
  count          = var.env == "PROD" ? 1 : 0
  source         = "./modules/azure_resources/loadbalancer"
  loadbalancer   = local.loadbalancer
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
}

# 
# loganalytics
# 
module "loganalytics" {
  # Alerts for log analytics service.
  source         = "./modules/azure_resources/loganalytics"
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
  oms            = var.oms
  rg-oms         = var.rg-oms
}

module "virtual_desktop_host_pool" {
  count                     = var.region == "AU" && var.env == "PROD" ? 1 : 0
  source                    = "./modules/azure_resources/vdesktop_hostpool"
  virtual_desktop_host_pool = data.azurerm_virtual_desktop_host_pool.pool[0]
  action_group              = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group            = azurerm_resource_group.rg_alerts.name
  env                       = var.env
  region                    = var.region
  sub                       = var.sub
  team                      = local.teamTag.INF
  rolloutStage              = local.rolloutStages.Switch
}

module "healthAlerts" {
  # This will create sql monitor alerts.
  source                 = "./modules/azure_resources/health"
  count                  = var.env == "PROD" ? 1 : 0
  action_group_pagerduty = azurerm_monitor_action_group.pagerDuty.id
  action_group_email     = azurerm_monitor_action_group.SREGroupEmail.id
  resource_group         = azurerm_resource_group.rg_alerts.name
  env                    = var.env
  region                 = var.region
  sub                    = var.sub
}

module "AIApimSloAlerts-AU" {
  # Slo alert strategy implemented on APIM to monitor all api endpoints 
  source         = "./modules/azure_resources/ai_apim_slo"
  count          = var.region == "AU" && var.env == "PROD" ? 1 : 0
  ai_apim_slo    = local.ai_apim_slo_au
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
  ai-apim        = data.azurerm_application_insights.ai-apim
}
module "AIApimSloAlerts-ON" {
  # Slo alert strategy implemented on APIM to monitor all api endpoints 
  source         = "./modules/azure_resources/ai_apim_slo"
  count          = var.region == "ON" && var.env == "PROD" ? 1 : 0
  ai_apim_slo    = local.ai_apim_slo_on
  action_group   = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
  resource_group = azurerm_resource_group.rg_alerts.name
  env            = var.env
  region         = var.region
  sub            = var.sub
  ai-apim        = data.azurerm_application_insights.ai-apim
}
