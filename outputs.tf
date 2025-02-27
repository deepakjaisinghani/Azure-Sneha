data "azurerm_application_insights" "ai-apim" {
  name                = var.ai-apim == "" ? "ai-apimanagement-${var.region}-${var.env}" : var.ai-apim
  resource_group_name = var.rg-ai-apim == "" ? "rg-apim-${var.region}-${var.env}" : var.rg-ai-apim
}

data "azurerm_application_insights" "ai-account" {
  name                = var.ai-account == "" ? "AI-FNAPP-AccountEngine-${var.region}-${var.env}" : var.ai-account
  resource_group_name = var.rg-ai-account == "" ? "RG-AccountEngine-${var.region}-${var.env}" : var.rg-ai-account
}

data "azurerm_application_insights" "ai-fobm" {
  name                = var.ai-fobm == "" ? "AI-FNAPP-FixedOddsBets-${var.region}-${var.env}" : var.ai-fobm
  resource_group_name = var.rg-ai-fobm == "" ? "RG-FixedOddsBets-${var.region}-${var.env}" : var.rg-ai-fobm
}

data "azurerm_application_insights" "ai-mes" {
  name                = var.ai-mes == "" ? "AI-Marketentitiesengine-${var.region}-${var.env}" : var.ai-mes
  resource_group_name = var.rg-ai-mes == "" ? "RG-Marketentitiesengine-${var.region}-${var.env}" : var.rg-ai-mes
}

data "azurerm_application_insights" "ai-microfrontend" {
  name                = var.ai-microfrontend == "" ? "AI-MicroFrontend-${var.region}-${var.env}" : var.ai-microfrontend
  resource_group_name = var.rg-ai-microfrontend == "" ? "RG_Signup_${var.region}_${var.env}" : var.rg-ai-microfrontend
}

data "azurerm_application_insights" "ai-tbsbet" {
  name                = var.ai-tbsbet == "" ? "AI-FNAPP-TbsEngine-${var.region}-${var.env}" : var.ai-tbsbet
  resource_group_name = var.rg-ai-tbsbet == "" ? "RG-TbsEngine-${var.region}-${var.env}" : var.rg-ai-tbsbet
}

data "azurerm_application_insights" "ai-tbs" {
  name                = var.ai-tbs == "" ? "AI-Tbs-${var.region}-${var.env}" : var.ai-tbs
  resource_group_name = var.rg-ai-tbs == "" ? "RG-coretbs-${var.region}-${var.env}" : var.rg-ai-tbs
}

data "azurerm_application_insights" "ai-spotspoller" {
  name                = var.ai-spotspoller == "" ? "AI-FNAPP-SpotsdbPoller-${var.region}-${var.env}" : var.ai-spotspoller
  resource_group_name = var.rg-ai-spotspoller == "" ? "RG-SpotsdbPoller-${var.region}-${var.env}" : var.rg-ai-spotspoller
}

data "azurerm_application_insights" "ai-regionaladapter" {
  name                = var.ai-regionaladapter == "" ? "AI-FNAPP-GlobalFeedsRegionalAdaptor-${var.region}-${var.env}" : var.ai-regionaladapter
  resource_group_name = var.rg-ai-regionaladapter == "" ? "RG-GlobalFeedsRegionalAdaptor-${var.region}-${var.env}" : var.rg-ai-regionaladapter
}

data "azurerm_application_insights" "ai-bfte" {
  name                = var.ai-bfte == "" ? "AI-FNAPP-Betfundstransfer-${var.region}-${var.env}" : var.ai-bfte
  resource_group_name = var.rg-ai-bfte == "" ? "RG-Betfundstransfer-${var.region}-${var.env}" : var.rg-ai-bfte
}

data "azurerm_application_insights" "ai-rewards" {
  name                = var.ai-rewards == "" ? "AI-FNAPP-RewardsEngine-${var.region}-${var.env}" : var.ai-rewards
  resource_group_name = var.rg-ai-rewards == "" ? "RG-RewardsEngine-${var.region}-${var.env}" : var.rg-ai-rewards
}

data "azurerm_log_analytics_workspace" "oms" {
  name                = var.oms == "" ? "OMS-${var.region}-${var.env}" : var.oms
  resource_group_name = var.rg-oms == "" ? "RG-Logs-${var.region}-${var.env}" : var.rg-oms
}


data "azurerm_application_insights" "ai-kycengine" {
  name                = var.ai-kyc == "" ? "AI-FNAPP-KycEngine-${var.region}-${var.env}" : var.ai-kyc
  resource_group_name = var.rg-ai-kyc == "" ? "RG-KycEngine-${var.region}-${var.env}" : var.rg-ai-kyc
}

data "azurerm_application_insights" "ai-cage" {
  name                = var.ai-cage == "" ? "AI-Cage-${var.region}-${var.env}" : var.ai-cage
  resource_group_name = var.rg-ai-cage == "" ? "RG-Cage-${var.region}-${var.env}" : var.rg-ai-cage
}

data "azurerm_application_insights" "ai-payment" {
  name                = var.ai-payment == "" ? "AI-FNAPP-PaymentEngine-${var.region}-${var.env}" : var.ai-payment
  resource_group_name = var.rg-ai-payment == "" ? "RG-PaymentEngine-${var.region}-${var.env}" : var.rg-ai-payment
}

data "azurerm_application_insights" "ai-racingform" {
  count               = var.region == "AU" ? 1 : 0
  name                = var.ai-racingform == "" ? "ai-fnapp-racingformengine-${var.region}-${var.env}" : var.ai-racingform
  resource_group_name = var.rg-ai-racingform == "" ? "rg-racingformengine-${var.region}-${var.env}" : var.rg-ai-racingform
}

data "azurerm_application_insights" "ai-racingservice" {
  count               = var.region == "AU" ? 1 : 0
  name                = var.ai-racingservice == "" ? "ai-racingservice-${var.region}-${var.env}" : var.ai-racingservice
  resource_group_name = var.rg-ai-racingform == "" ? "rg-racingservice-${var.region}-${var.env}" : var.rg-ai-racingservice
}

data "azurerm_application_insights" "ai-kyc" {
  name                = var.ai-kyc == "" ? "AI-FNAPP-KycEngine-${var.region}-${var.env}" : var.ai-kyc
  resource_group_name = var.rg-ai-kyc == "" ? "RG-KycEngine-${var.region}-${var.env}" : var.rg-ai-kyc
}

data "azurerm_application_insights" "ai-phonecodes" {
  count               = var.region == "AU" ? 1 : 0
  name                = var.ai-phonecodes == "" ? "ai-fnapp-phonecodes-${var.region}-${var.env}" : var.ai-phonecodes
  resource_group_name = var.rg-phonecodes == "" ? "rg-phonecodes-${var.region}-${var.env}" : var.rg-phonecodes
}

data "azurerm_application_insights" "ai-wallet" {
  name                = var.ai-wallet == "" ? "AI-FNAPP-WalletEngine-${var.region}-${var.env}" : var.ai-wallet
  resource_group_name = var.rg-ai-wallet == "" ? "RG-WalletEngine-${var.region}-${var.env}" : var.rg-ai-wallet
}

data "azurerm_application_insights" "ai-casino-usage" {
  count               = var.region == "ON" ? 1 : 0
  name                = var.ai-casino-usage
  resource_group_name = var.rg-casino-usage == "" ? "rg-casinousageservice-${var.region}-${var.env}" : var.rg-casino-usage
}

data "azurerm_application_insights" "ai-cashout" {
  name                = var.ai-cashout == "" ? "AI-FNAPP-CashoutEngine-${var.region}-${var.env}" : var.ai-cashout
  resource_group_name = var.rg-ai-cashout == "" ? "RG-CashoutEngine-${var.region}-${var.env}" : var.rg-ai-cashout
}

data "azurerm_application_insights" "ai-selfexclusionengine" {
  count               = var.region == "AU" ? 1 : 0
  name                = "ai-selfexclusionengine-${var.region}-${var.env}"
  resource_group_name = "rg-selfexclusionengine-${var.region}-${var.env}"
}

data "azurerm_application_insights" "ai" {
  for_each            = local.app_insights_common
  name                = each.value.ai_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_monitor_action_group" "racing-service-slack-proxy" {
  count               = var.region == "AU" && var.env == "PROD" ? 1 : 0
  name                = "racing service slack proxy"
  resource_group_name = "rg-racingservice-au-prod"
}

data "azurerm_application_insights" "ai-authserver" {
  count               = var.region == "AU" ? 1 : 0
  name                = "ai-auth-server-${var.region}-${var.env}"
  resource_group_name = "rg-auth-server-${var.region}-${var.env}"
}

data "azurerm_application_insights" "ai-notificationengine" {
  count               = var.region == "AU" ? 1 : 0
  name                = "ai-fnapp-notificationengine-${var.region}-${var.env}"
  resource_group_name = "rg-notificationengine-${var.region}-${var.env}"
}

data "azurerm_application_insights" "ai-betty" {
  name                = "ai-fnapp-betty-${var.region}-${var.env}"
  resource_group_name = "rg-betty-${var.region}-${var.env}"
}

data "azurerm_virtual_desktop_host_pool" "pool" {
  count               = var.region == "AU" && var.env == "PROD" ? 1 : 0
  name                = "AUSHostPool"
  resource_group_name = "RG_Nerdio_AU"
}

data "azurerm_application_insights" "ai-casino-cml" {
  count               = var.region == "ON" ? 1 : 0
  name                = "ai-casinocml-${var.region}-${var.env}"
  resource_group_name = "rg-casinocml-${var.region}-${var.env}"
}
