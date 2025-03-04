locals {
  #  Team tag is passed into alert description and used for routing in Pagerduty global Orchestration
  teamTag = {
    SRE : "Team-SRE",
    INF : "Team-Infrastructure",
    NET : "Team-Network",
    CPE : "Team-CPE",
    DBA : "Team-Database",
    FRT : "Team-Frontend",
    PMO : "Team-Primo",
    RAC : "Team-Racing",
    IFT : "Team-Infinity",
    SPT : "Team-Sport",
    ARA : "Team-Aurora",
    PLU : "Team-Plutus",
    WNX : "Team-WINX",
    HML : "Team-Himalayas",
    NGR : "Team-Nilgiris"
  }
  rolloutStages = {
    Initial : "STAGE1",
    Switch : "STAGE3",
  }
  microfrontend_resource = {
    AI : "AI-MicroFrontend-${var.region}-${var.env}",
    RG : "RG_Signup_${var.region}_${var.env}"
  }
  # 
  # app_insights
  # 
  app_insights_common = merge({
    APIM = {
      "ai_name"                       = "ai-apimanagement-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.APIM
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.APIM
      "resource_group_name"           = coalesce(var.rg-ai-apim, "rg-apim-${var.region}-${var.env}")
      "team"                          = local.teamTag.SRE
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    Cashout = {
      "ai_name"                       = contains(["AU"], var.region) ? coalesce(var.ai-cashout, "AI-FNAPP-CashoutEngineAPI-${var.region}-${var.env}") : coalesce(var.ai-cashout, "AI-FNAPP-CashoutEngine-${var.region}-${var.env}")
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.cashoutengine
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-cashout, "RG-CashoutEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.SPT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    SingleCustomerView = {
      "ai_name"                       = "ai-fnapp-singlecustomerview-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.SingleCustomerView
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-singlecustomerview, "rg-singlecustomerview-${var.region}-${var.env}")
      "team"                          = local.teamTag.SRE
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    WebjobRabbitMQ = {
      "ai_name"                       = "AI-WebJob-RabbitMQ-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-webjob-rabbitmq, "RG-RabbitMQWebJob-${var.region}-${var.env}")
      "team"                          = local.teamTag.SRE
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }

    BetgeniusFeedConsumer = {
      "ai_name"                       = "AI-BetgeniusFeedConsumer-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-bgfeedconsumer, "RG-BetgeniusFeedConsumer-${var.region}-${var.env}")
      "team"                          = local.teamTag.SPT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }

    CageAPI = {
      "ai_name"                       = "AI-Cage-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-cage, "RG-Cage-${var.region}-${var.env}")
      "team"                          = local.teamTag.SRE
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    AccountEngine = {
      "ai_name"                       = "AI-FNAPP-AccountEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.AccountEngine
      "resource_group_name"           = coalesce(var.rg-ai-account, "RG-AccountEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    BetEngine = {
      "ai_name"                       = "AI-FNAPP-BetEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.ai-betengine, "RG-BetEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.SRE
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    BFTEngine = {
      "ai_name"                       = "AI-FNAPP-Betfundstransfer-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-bfte, "RG-Betfundstransfer-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    BetInfoAPI = {
      "ai_name"                       = "AI-FNAPP-BetinfoApi-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT1H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-betinfo, "RG-BetinfoApi-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    EventsMarketsImporter = {
      "ai_name"                       = "AI-FNAPP-EventsmarketsImporter-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-eventsimporter, "RG-EventsmarketsImporter-${var.region}-${var.env}")
      "team"                          = local.teamTag.SPT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    ExternalServices = {
      "ai_name"                       = "AI-FNAPP-ExternalServicesEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT1H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-extservice, "RG-ExternalServicesEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.NGR
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    FixedOddsBets = {
      "ai_name"                       = "AI-FNAPP-FixedOddsBets-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-fobm, "RG-FixedOddsBets-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    KYCEngine = {
      "ai_name"                       = "AI-FNAPP-KycEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = local.requests_failure_queries.KYCEngine
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.KYCEngine
      "resource_group_name"           = coalesce(var.rg-ai-kyc, "RG-KycEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    LossCoverEngine = {
      "ai_name"                       = "AI-FNAPP-LossCoverEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-losscover, "RG-LossCoverEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    # Using log alert for failures
    MarketEntitiesEngine = {
      "ai_name"                       = "AI-Marketentitiesengine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.MarketEntitiesEngine
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.MarketEntitiesEngine
      "resource_group_name"           = coalesce(var.rg-ai-mes, "RG-Marketentitiesengine-${var.region}-${var.env}")
      "team"                          = local.teamTag.SPT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    NotificationEngine = {
      "ai_name"                       = "AI-FNAPP-NotificationEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = local.requests_failure_queries.NotificationEngine
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-notification, "RG-NotificationEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    PaymentEngine = {
      "ai_name"                       = "AI-FNAPP-PaymentEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = false
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.PaymentEngine
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.PaymentEngine
      "resource_group_name"           = coalesce(var.rg-ai-payment, "RG-PaymentEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.PLU
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    PromoEngine = {
      "ai_name"                       = "AI-FNAPP-PromoEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = var.region == "AU" ? true : false
      "enable-exceptions-dt"          = var.region == "ON" ? true : false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = local.requests_failure_queries.PromoEngine
      "query-exceptions"              = local.exceptions_queries.PromoEngine
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.PromoEngine
      "resource_group_name"           = coalesce(var.rg-ai-promo, "RG-PromoEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.PMO
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    QuickMultiEngine = {
      "ai_name"                       = "AI-FNAPP-QuickMultiEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-quickmulti, "RG-QuickMultiEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.PMO
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    ResponsibleGambling = {
      "ai_name"                       = "AI-FNAPP-ResponsibleGambling-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.ResponsibleGambling
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.ResponsibleGambling
      "resource_group_name"           = coalesce(var.ai-responsiblegambling, "RG-ResponsibleGambling-${var.region}-${var.env}")
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    RewardsEngine = {
      "ai_name"                       = "AI-FNAPP-RewardsEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = var.region == "AU" ? true : false
      "enable-exceptions-dt"          = var.region == "ON" ? true : false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = var.region == "AU" ? local.requests_failure_queries.RewardsEngine : local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.RewardsEngine
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-rewards, "RG-RewardsEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.PMO
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    SpreadBet = {
      "ai_name"                       = "AI-FNAPP-SpreadEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT1H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-spreadbet, "RG-SpreadEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    TbsBet = {
      "ai_name"                       = "AI-FNAPP-TbsEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT1H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.TbsBet
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-tbsbet, "RG-TbsEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    Tbs = {
      "ai_name"                       = "AI-Tbs-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.Tbs
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.Tbs
      "resource_group_name"           = coalesce(var.rg-ai-tbs, "RG-coretbs-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    WalletEngine = {
      "ai_name"                       = "AI-FNAPP-WalletEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = true
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.WalletEngine
      "query-response-time"           = local.response_time_queries.WalletEngine
      "resource_group_name"           = coalesce(var.rg-ai-wallet, "RG-WalletEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.PLU
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    WithdrawalAssesmentEngine = {
      "ai_name"                       = "AI-FNAPP-WithdrawalAssessmentEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.WithdrawalAssesmentEngine
      "resource_group_name"           = coalesce(var.rg-ai-withdrawal, "RG-WithdrawalAssessmentEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.PLU
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    OpsAPIEngine = {
      "ai_name"                       = "AI-FNAPP-OpstechApiEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "P1D"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-opsapi, "RG-OpstechApiEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.SRE
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    OpstechBulk = {
      "ai_name"                       = "ai-fnapp-opstechbulkoperation-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "P1D"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-opsbulk, "rg-opstechbulkoperation-${var.region}-${var.env}")
      "team"                          = local.teamTag.SRE
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    RegionalAdapter = {
      "ai_name"                       = "AI-FNAPP-GlobalFeedsRegionalAdaptor-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-regionaladapter, "RG-GlobalFeedsRegionalAdaptor-${var.region}-${var.env}")
      "team"                          = local.teamTag.SPT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    SignalR = {
      "ai_name"                       = "AI-SignalrService-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.SignalR
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-signalr, "RG-SignalrService-${var.region}-${var.env}")
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    SpotsDBPoller = {
      "ai_name"                       = "AI-FNAPP-SpotsdbPoller-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.SpotsDbPoller
      "resource_group_name"           = coalesce(var.rg-ai-spotspoller, "RG-SpotsdbPoller-${var.region}-${var.env}")
      "team"                          = local.teamTag.PLU
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    Regional-Presentation-Adapter = {
      "ai_name"                       = "ai-fnapp-regionalpresentationadapter-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-regional-presentation-adapter, "rg-regionalpresentationadapter-${var.region}-${var.env}")
      "team"                          = local.teamTag.SPT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    Betty = {
      "ai_name"                       = "ai-fnapp-betty-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = false //172259
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.Betty
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.Betty
      "resource_group_name"           = coalesce(var.rg-ai-betty, "rg-betty-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    BettyReporting = {
      "ai_name"                       = "ai-fnapp-bettyreporting-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT12H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.BettyReporting
      "resource_group_name"           = coalesce(var.rg-ai-bettyreporting, "rg-bettyreporting-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    BetHistory = {
      "ai_name"                       = "ai-fnapp-bethistory-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.BetHistory
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-bethistory, "rg-bethistory-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    PromoTokens = {
      "ai_name"                       = "ai-fnapp-promotokens-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false //SD-57879
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.PromoTokens
      "resource_group_name"           = coalesce(var.rg-ai-promotokens, "rg-promotokens-${var.region}-${var.env}")
      "team"                          = local.teamTag.PMO
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    },
    var.env == "PROD" ? {
      MarketManager = {
        "ai_name"                       = "appi-market-manager-api-${var.region}-${var.env}"
        "enable-requests-failure-log"   = false
        "enable-requests-failure-dt"    = true
        "enable-exceptions-log"         = false
        "enable-exceptions-dt"          = true
        "enable-dependency-failure-log" = false
        "enable-dependency-failure-dt"  = true
        "enable-response-time-log"      = true
        "enable-no-data-alerts"         = true
        "no-data-window-size"           = "PT30M"
        "query-requests-failure"        = local.requests_failure_queries.default
        "query-exceptions"              = local.exceptions_queries.default
        "query-dependency-failure"      = local.dependency_failure_queries.default
        "query-response-time"           = local.response_time_queries.MarketManager
        "resource_group_name"           = coalesce(var.rg-ai-marketmanager, "rg-market-manager-api-${var.region}-${var.env}")
        "team"                          = local.teamTag.SPT
        "rolloutStages" = {
          "requests-failure-log"   = local.rolloutStages.Initial
          "requests-failure-dt"    = local.rolloutStages.Initial
          "exceptions-log"         = local.rolloutStages.Initial
          "exceptions-dt"          = local.rolloutStages.Initial
          "dependency-failure-log" = local.rolloutStages.Initial
          "dependency-failure-dt"  = local.rolloutStages.Initial
          "response-time-log"      = local.rolloutStages.Initial
        }
      }
  } : {})
  app_insights_au = {
    PhoneCodes = {
      "ai_name"                       = "ai-fnapp-phonecodes-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.PhoneCodes
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-phonecodes, "rg-phonecodes-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    AuthServer = {
      "ai_name"                       = "ai-auth-server-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = true
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = true
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.AuthServer
      "query-exceptions"              = local.exceptions_queries.AuthServer
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.AuthServer
      "resource_group_name"           = coalesce(var.rg-authserver, "rg-auth-server-${var.region}-${var.env}")
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    NTRCAudit = {
      "ai_name"                       = "ai-fnapp-ntrcauditengine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-authserver, "rg-ntrcauditengine-${var.region}-${var.env}")
      "team"                          = local.teamTag.IFT
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    SelfExclusionImport = {
      "ai_name"                       = "ai-fnapp-selfexclusionimport-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "P1D"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-selfexclusionimport, "rg-selfexclusionimport-${var.region}-${var.env}")
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    TaxFormService = {
      "ai_name"                       = "ai-taxformservice-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-taxformservice, "rg-taxformservice-${var.region}-${var.env}")
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    TurnOverEngine = {
      "ai_name"                       = "ai-fnapp-turnoverengine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = true
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = true
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.TurnOverEngine
      "query-exceptions"              = local.exceptions_queries.TurnOverEngine
      "query-dependency-failure"      = local.dependency_failure_queries.TurnOverEngine
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-turnover, "rg-turnoverengine-${var.region}-${var.env}")
      "team"                          = local.teamTag.PLU
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    RacingService = {
      "ai_name"                       = "ai-racingservice-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = true
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.RacingService
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.RacingService
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-racingservice, "rg-racingservice-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    RacingFeed = {
      "ai_name"                       = "ai-racingfeed-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.RacingFeed
      "resource_group_name"           = coalesce(var.rg-racingfeed, "rg-racingfeed-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }
    SameRaceMulti = {
      "ai_name"                       = "ai-sameracemulti-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = false
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-sameracemulti, "rg-sameracemulti-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    SelfExclusionEngine = {
      "ai_name"                       = "ai-selfexclusionengine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = true
      "enable-exceptions-dt"          = false
      "enable-dependency-failure-log" = true
      "enable-dependency-failure-dt"  = false
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.SelfExclusionEngine
      "query-dependency-failure"      = local.dependency_failure_queries.SelfExclusionEngine
      "query-response-time"           = local.response_time_queries.SelfExclusionEngine
      "resource_group_name"           = "rg-selfexclusionengine-${var.region}-${var.env}"
      "team"                          = local.teamTag.ARA
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Initial
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Initial
      }
    }

    RacingFeedBetmakers = {
      "ai_name"                       = "ai-racingfeedbetmakers-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-racingfeedbetmakers, "rg-racingfeedbetmakers-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }

    RacingFeedService = {
      "ai_name"                       = "ai-racingfeedservice-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-racingfeedservice, "rg-racingfeedservice-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }

    RacingFeedTracker = {
      "ai_name"                       = "ai-racingfeedtracker-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-racingfeedtracker, "rg-racingfeedtracker-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }

    RacingKeepAlive = {
      "ai_name"                       = "ai-racingkeepalive-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-racingkeepalive, "rg-racingkeepalive-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }

    VenueService = {
      "ai_name"                       = "ai-venueservice-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-racingkeepalive, "rg-venueservice-${var.region}-${var.env}")
      "team"                          = local.teamTag.RAC
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Initial
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Initial
        "exceptions-dt"          = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "dependency-failure-log" = local.rolloutStages.Initial
        "dependency-failure-dt"  = var.region == "AU" && var.env == "PROD" ? data.azurerm_monitor_action_group.racing-service-slack-proxy[0].id : local.rolloutStages.Initial
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
  }
  app_insights_on = {
    StriveCasinoForwarderEngine = {
      "ai_name"                       = "ai-casinoeventsforwarderengine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-casinoeventsforwarderengine, "rg-casinoeventsforwarderengine-${var.region}-${var.env}")
      "team"                          = local.teamTag.NGR
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    CasinoCML = {
      "ai_name"                       = "AI-CasinoCml-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.CasinoCML
      "resource_group_name"           = coalesce(var.rg-ai-casinocml, "RG-CasinoCml-${var.region}-${var.env}")
      "team"                          = local.teamTag.HML
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    # Using log alert for failures
    GlobalAccountEngine = {
      "ai_name"                       = "AI-FNAPP-GlobalAccountEngine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = false
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.Exclude_AU
      "resource_group_name"           = coalesce(var.rg-ai-globalaccount, "RG-GlobalAccountEngine-${var.region}-${var.env}")
      "team"                          = local.teamTag.NGR
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    StriveCasinoAdapterEngine = {
      "ai_name"                       = "ai-casinoeventsadapterengine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = true
      "no-data-window-size"           = "PT15M"
      "query-requests-failure"        = local.requests_failure_queries.StriveCasino
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-casinoeventsadapterengine, "rg-casinoeventsadapterengine-${var.region}-${var.env}")
      "team"                          = local.teamTag.NGR
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    StriveCasinoConsumerEngine = {
      "ai_name"                       = "ai-casinoeventsconsumerengine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT1H"
      "query-requests-failure"        = local.requests_failure_queries.StriveCasino
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-casinoeventsconsumerengine, "rg-casinoeventsconsumerengine-${var.region}-${var.env}")
      "team"                          = local.teamTag.NGR
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
    StriveCasinoNotificationEngine = {
      "ai_name"                       = "ai-casinoeventsnotificationengine-${var.region}-${var.env}"
      "enable-requests-failure-log"   = true
      "enable-requests-failure-dt"    = true
      "enable-exceptions-log"         = false
      "enable-exceptions-dt"          = true
      "enable-dependency-failure-log" = false
      "enable-dependency-failure-dt"  = true
      "enable-response-time-log"      = true
      "enable-no-data-alerts"         = false
      "no-data-window-size"           = "PT6H"
      "query-requests-failure"        = local.requests_failure_queries.default
      "query-exceptions"              = local.exceptions_queries.default
      "query-dependency-failure"      = local.dependency_failure_queries.default
      "query-response-time"           = local.response_time_queries.default
      "resource_group_name"           = coalesce(var.rg-ai-casinoeventsnotificationengine, "rg-casinoeventsnotificationengine-${var.region}-${var.env}")
      "team"                          = local.teamTag.NGR
      "rolloutStages" = {
        "requests-failure-log"   = local.rolloutStages.Switch
        "requests-failure-dt"    = local.rolloutStages.Switch
        "exceptions-log"         = local.rolloutStages.Switch
        "exceptions-dt"          = local.rolloutStages.Switch
        "dependency-failure-log" = local.rolloutStages.Switch
        "dependency-failure-dt"  = local.rolloutStages.Switch
        "response-time-log"      = local.rolloutStages.Switch
      }
    }
  }
  microfrontend_businessfunc = {
    Deposit = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.Deposit
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.Empty
      "enable-performance-query" = false
    }
    Withdraw = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.Withdraw
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.Empty
      "enable-performance-query" = false
    }
    Betting = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.Betting
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.Betting
      "enable-performance-query" = false
    }
    Signup = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.Signup
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.Empty
      "enable-performance-query" = false
    }
    Login = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.Login
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.Login
      "enable-performance-query" = false
    }
    ForgotPassword = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.ForgotPassword
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.Empty
      "enable-performance-query" = false
    }
    ResponsibleGambling = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.ResponsibleGambling
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.ResponsibleGambling
      "enable-performance-query" = false
    }
    Microfrontend = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.Microfrontend
      "enable-failure-query"     = false
      "performance-query"        = local.business_func_queries.performance.Empty
      "enable-performance-query" = false
    }
    AccountBalance = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.AccountBalance
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.Empty
      "enable-performance-query" = false
    }
    Mfa = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.Mfa
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.Empty
      "enable-performance-query" = false
    }
    GeoComply = {
      "ai_name"                  = local.microfrontend_resource.AI
      "resource_group_name"      = local.microfrontend_resource.RG
      "team"                     = local.teamTag.SRE
      "failure-query"            = local.business_func_queries.failure.GeoComply
      "enable-failure-query"     = true
      "performance-query"        = local.business_func_queries.performance.GeoComply
      "enable-performance-query" = false
    }
  }

  # servicebus or service bus
  servicebus_common = {
    NotMonitored = {
      "enable"              = false
      "threshold-activemsg" = 1000
      "threshold-dlq"       = 1000
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["betty-internal-messaging", "betengine-spreadevents", "marketentitiesstore-enricheventcommands-session", "marketentitiesstore-tbsspotsdbsynccommands", "accountengine-userevents", "marketentitiesstore-fixedoddsmarketchanged", "paymentengine-incomingcommands", "betty-internal-reporting"]

    }
    MarketEntitiesStore = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-mes-activecount
      "threshold-dlq"       = var.sb-premium-mes-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["marketentitiesstore-enricheventcommands", "marketentitiesstore-enrichmastereventcommands", "marketentitiesstore-enrichspreadscommands", "marketentitiesstore-outcomescratched-oddsboost", "marketentitiesstore-outcomescratched-tbsengine", "marketentitiesstore-seedcommands", "marketentitiesstore-enrichracingeventcommands", "marketentitiesstore-fixedoddsmarketresults", "marketentitiesstore-outcomescratched", "marketentitiesstore-sporteventchanged", "marketentitiesstore-spreadmarketschanged", "marketentitiesstore-wss"]
    }
    BetFundTransfer = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-bfte-activecount
      "threshold-dlq"       = var.sb-premium-bfte-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["fixedoddsbetsmessageengine-betcancelledcommands", "fixedoddsbetsmessageengine-betinterceptedcommands", "fixedoddsbetsmessageengine-betpayoutcommands", "fixedoddsbetsmessageengine-betplacedcommands", "fixedoddsevents", "fixedoddsbetsmessageengine-betcancelledcommands-betfundstransferengine", "fixedoddsbetsmessageengine-betcancelledcommands-betsyncpollingengine", "fixedoddsbetsmessageengine-betcancelledcommands-oddsboost", "fixedoddsbetsmessageengine-betinterceptedcommands-betfundstransferengine", "fixedoddsbetsmessageengine-betinterceptedcommands-oddsboost", "fixedoddsbetsmessageengine-betpayoutcommands-betfundstransferengine", "fixedoddsbetsmessageengine-betpayoutcommands-betsyncpollingengine", "fixedoddsbetsmessageengine-betpayoutcommands-ustaxalert ", "fixedoddsbetsmessageengine-betplacedcommands-betfundstransferengine", "fixedoddsbetsmessageengine-betplacedcommands-oddsboost", "fixedoddsbetsmessageengine-betplacedcommands-onboardingtasks", "fixedoddsbetsmessageengine-enrichbetcancelledcommands", "fixedoddsbetsmessageengine-enrichbetsettledcommands", "fixedoddsbetsmessageengine-enricheventsettledcommands"]
    }
    Account = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-account-activecount
      "threshold-dlq"       = var.sb-premium-account-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["accountengine-balancetransfer", "accountengine-highprioritycommands", "accountengine-internalcommands", "promoevents"]
    }
    Payment = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-payment-activecount
      "threshold-dlq"       = var.sb-premium-payment-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["paymentengine-paymentevents", "paymentengine-commbank", "paymentengine-commbank-file", "paymentengine-verifiednumcommands"]
    }
    BetEngine = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-betengine-activecount
      "threshold-dlq"       = var.sb-premium-betengine-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["betsync-unsettledbetreconcilercommands", "betplacement-intercept"]
    }
    LossCover = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-losscover-activecount
      "threshold-dlq"       = var.sb-premium-losscover-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["losscoverengine-losscoverevents"]
    }
    Websocket = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-websocket-activecount
      "threshold-dlq"       = var.sb-premium-websocket-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["websocket"]
    }
    UBI = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-ubi-activecount
      "threshold-dlq"       = var.sb-premium-ubi-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["unifiedbetinterceptenrichmentservice-betinterceptedcommands"]
    }
    SpotsDBPoller = {
      "enable"              = false
      "threshold-activemsg" = var.sb-premium-spotsdb-activecount
      "threshold-dlq"       = var.sb-premium-spotsdb-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["exportedevents"]
    }
    TBSCommands = {
      "enable"              = false
      "threshold-activemsg" = var.sb-premium-tbscommands-activecount
      "threshold-dlq"       = var.sb-premium-tbscommands-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["tbscommands", "tbsmarketcommands", "tbsbalancetransfercommands"]
    }
    Wallet = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-wallet-activecount
      "threshold-dlq"       = var.sb-premium-wallet-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["walletengine-incomingcommands", "walletengine-reconciler-tbsengine", "walletengine-reconciler"]
    }
    BFTRewards = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-bfte-rewards-activecount
      "threshold-dlq"       = var.sb-premium-bfte-rewards-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["fixedoddsbetsmessageengine-betplacedcommands-rewardsengine", "fixedoddsbetsmessageengine-betpayoutcommands-rewardsengine"]
    }
    GlobalAccountEngine = {
      "enable"              = false
      "threshold-activemsg" = var.sb-premium-gae-activecount
      "threshold-dlq"       = var.sb-premium-gae-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["globalaccountengine-events"]
    }
    NotificationEngine = {
      "enable"              = false
      "threshold-activemsg" = var.sb-premium-NotificationEngine-activecount
      "threshold-dlq"       = var.sb-premium-NotificationEngine-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["notificationengine-smsevents", "notificationengine-commands", "monthly-activity-statement"]
    }
    Promoengine = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-Promoengine-activecount
      "threshold-dlq"       = var.sb-premium-Promoengine-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["promoengine-userfirstbet", "promoengine-userfirstbet-migration", "promoengine-completeonboardingtask", "promoengine-updateuserdepositpromo"]
    }
    SpreadEngine = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-spreadengine-activecount
      "threshold-dlq"       = var.sb-premium-spreadengine-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["spreadengine-betintercepted", "spreadengine-betinterceptstatus"]
    }
    TBS = {
      "enable"              = false
      "threshold-activemsg" = var.sb-premium-tbs-activecount
      "threshold-dlq"       = var.sb-premium-tbs-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["tbsevents"]
    }
    ASYNCJob = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-asyncjob-activecount
      "threshold-dlq"       = var.sb-premium-asyncjob-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["asyncjob-requests"]
    }
    Incoming = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-incomingcommands-activecount
      "threshold-dlq"       = var.sb-premium-incomingcommands-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["incomingcommands", "incomingevents"]
    }
    KYCEngine = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-KYCEngine-activecount
      "threshold-dlq"       = var.sb-premium-KYCEngine-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["kycengine_incomingcommands"]
    }
    PricingEngine = {
      "enable"              = false
      "threshold-activemsg" = var.sb-premium-PricingEngine-activecount
      "threshold-dlq"       = var.sb-premium-PricingEngine-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["pricingengine-session"]
    }
    RewardsEngine = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-RewardsEngine-activecount
      "threshold-dlq"       = var.sb-premium-RewardsEngine-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["rewardsengine-bulk-bonus-creditor"]
    }
    BetGenius = {
      "enable"              = false
      "threshold-activemsg" = var.sb-premium-BetGenius-activecount
      "threshold-dlq"       = var.sb-premium-BetGenius-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["betgenius-feed", "betgenius-heartbeat"]
    }
    PromoToken = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-PromoToken-activecount
      "threshold-dlq"       = var.sb-premium-PromoToken-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["tbscommandstopic-tbsengine", "tbscommandstopic-promotokens"]
    }
  }
  servicebus_betty = {
    Betty = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-Betty-activecount
      "threshold-dlq"       = var.sb-premium-Betty-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["betty-bet-events-bet-history", "betty-bet-events-betmonitorenrichment", "betty-internal-placement-delay", "betty-internal-placement-intercept", "betty-internal-settlement-bet", "betty-internal-settlement-market", "betty-bet-events", "betty-bet-events-simple"]
    }
  }
  servicebus_au = {
    PromoTokens = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-PromoTokens-activecount
      "threshold-dlq"       = var.sb-premium-PromoTokens-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["fixedoddsbetsmessageengine-betinterceptedcommands-promotokens", "fixedoddsbetsmessageengine-betpayoutcommands-promotokens", "legresultenrichmentservice-promotokens", "fixedoddsbetsmessageengine-betcancelledcommands-promotokens"]
    }
    NTRCAudit = {
      "enable"              = false
      "threshold-activemsg" = var.sb-premium-NTRCAudit-activecount
      "threshold-dlq"       = var.sb-premium-NTRCAudit-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["ntrc-auditlog-betty", "ntrc-auditlog-spots", "ntrc-auditlog-spreadbets"]
    }

    RacingFeed = {
      "enable"              = true
      "threshold-activemsg" = var.sb-premium-RacingFeed-activecount
      "threshold-dlq"       = var.sb-premium-RacingFeed-dlqcount
      "action_group"        = var.env == "PROD" ? azurerm_monitor_action_group.pagerDuty.id : azurerm_monitor_action_group.uat-alerts-slack.id
      "values"              = ["racing-feed-betmakers-ingestion-queue", "racing-keep-alive-receiver", "racing-featuredcandidate", "racing-keep-alive"]
    }
  }

  eventhub_au = {
    Shared = {
      "eventhub_name"       = coalesce(var.eventhub-racing, "eh-racing-au-${var.env}")
      "resource_group_name" = coalesce(var.rg-eventhub-racing, "rg-racing-common-infra-au-${var.env}")
    }
  }
  # 
  # cosmos
  # 
  cosmos_common = {
    ExternalAuth = {
      "RequestThrottling"   = var.cosmos-externalauth-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = coalesce(var.cosmos-externalauth, "docdb-externalauth-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-cosmos-externalauth, "rg-externalauth-${var.region}-${var.env}")
      "enable"              = true
    }
    Oddsboost = {
      "RequestThrottling"   = var.cosmos-oddsboost-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = coalesce(var.cosmos-oddsboost, "docdb-oddsboost-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-cosmos-oddsboost, "rg-oddsboostengine-${var.region}-${var.env}")
      "enable"              = true
    }
    Pricingengine = {
      "RequestThrottling"   = var.cosmos-pricing-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = coalesce(var.cosmos-pricing, "docdb-pricingengine-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-cosmos-pricing, "rg-pricingengine-${var.region}-${var.env}")
      "enable"              = false
    }
    Promotions = {
      "RequestThrottling"   = var.cosmos-promotions-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = coalesce(var.cosmos-promotions, "docdb-promoengine-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-cosmos-promotions, "rg-promoengine-${var.region}-${var.env}")
      "enable"              = true
    }
    Rewards = {
      "RequestThrottling"   = var.cosmos-rewards-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = coalesce(var.cosmos-rewards, "docdb-rewardsengine-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-cosmos-rewards, "rg-rewardsengine-${var.region}-${var.env}")
      "enable"              = true
    }
    Sportingevent = {
      "RequestThrottling"   = var.cosmos-sportingevent-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = coalesce(var.cosmos-sportingevent, "docdb-sportingevent-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-cosmos-sportingevent, "rg-marketentitiesengine-${var.region}-${var.env}")
      "enable"              = true
    }
  }
  cosmos_au = {
    Racing = {
      "RequestThrottling"   = var.cosmos-racing-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = coalesce(var.cosmos-racing, "docdb-racing-service-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-cosmos-racing, "rg-racingservice-${var.region}-${var.env}")
      "enable"              = true
    }
    PhoneCodes = {
      "RequestThrottling"   = var.cosmos-phonecodes-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = coalesce(var.cosmos-phonecodes, "docdb-phone-codes-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-phonecodes, "rg-phonecodes-${var.region}-${var.env}")
      "enable"              = true
    }
    PromoTokens = {
      "RequestThrottling"   = var.cosmos-promotokens-throttlerequest-count
      "threshold"           = "Medium"
      "docdb_name"          = "docdb-promo-tokens-au-${var.env}"
      "resource_group_name" = "rg-promotokens-au-${var.env}"
      "enable"              = false
    }
  }
  cosmos_casino = {
    CasinoCML = {
      "RequestThrottling"   = var.cosmos-casinocml-throttlerequest-count
      "threshold"           = "High"
      "docdb_name"          = coalesce(var.cosmos-casinocml, "docdb-cmlcasino-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-cosmos-casinocml, "RG-CasinoCml-${var.region}-${var.env}")
      "enable"              = true
    }
    Casino = {
      "RequestThrottling"   = var.cosmos-casino-throttlerequest-count
      "threshold"           = "High"
      "docdb_name"          = coalesce(var.cosmos-casino, "docdb-casino-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-casino-usage, "rg-casinousageservice-${var.region}-${var.env}")
      "enable"              = true
    }
  }

  # 
  # redis
  # 
  redis_mes = {
    MES = {
      "redis_name"    = coalesce(var.redis-mes, "redis-marketentitiesengine-${var.region}-${var.env}")
      "redis_rg"      = coalesce(var.rg-redis-mes, "RG-Marketentitiesengine-${var.region}-${var.env}")
      "threshold_cpu" = var.redis-mes-cpu
      "threshold_mem" = var.redis-mes-mem
    }
  }

  #vm_rabbitmq = {
  #  RabbitMQLinux = {
  #    "vm_name"      = coalesce(var.vm-linux-tbs-rabbit, "vm-rabbitmq-${var.region}-${var.env}")
  #    "vm_rg"        = coalesce(var.rg-vm-linux-tbs-rabbit, "RG-CORE-BETTING-${var.region}-${var.env}")
  #    "threshold"    = var.vm-linux-tbs-rabbit-cpu
  #    "team"         = local.teamTag.SRE
  #   "rolloutStage" = local.rolloutStages.Initial
  #  }
  #}

  vm_dc = {
    DomainController = {
      "vm_name"      = coalesce(var.vm-dc, "VM-DC-${var.region}-${var.env}")
      "vm_rg"        = coalesce(var.rg-vm-dc, "RG_DC_${var.region}_${var.env}")
      "threshold"    = var.vm-dc-cpu
      "team"         = local.teamTag.INF
      "rolloutStage" = local.rolloutStages.Initial
    }
  }

  # 
  # sqlmonitor
  # 
  vm_sqlmonitor = {
    SQLMonitorWindows = {
      "vm_name"   = var.vm-win-sql-monitor
      "vm_rg"     = var.rg-vm-win-sql-monitor
      "threshold" = var.cpu-threshold
    }
  }
  # 
  # signalr
  # 
  signalr = {
    signalr = {
      "name"                = coalesce(var.signalr, "pb-signalr-${var.region}-${var.env}")
      "resource_group_name" = coalesce(var.rg-signalr, "RG-SignalrService-${var.region}-${var.env}")
    }
  }
  # 
  # app_service
  # 
  app_service_plan_igt = {
    IGTWebJob = {
      "asp_name"            = var.asp-igt
      "resource_group_name" = var.rg-asp-igt
      "cpu_threshold"       = var.ia_asp_cpu_threshold
      "memory_threshold"    = var.ia_asp_memory_threshold
    }
  }
  # 
  # app_service
  # 
  app_service_ia = {
    IGTWebJob = {
      "as_name"             = var.as-igt
      "resource_group_name" = var.rg-as-igt
    }
  }
  # 
  # 
  # firewall
  # 
  firewall = {
    FirewallFortiGateALinux = {
      "vm_name"      = var.vm-linux-lcl-FGT-A
      "vm_rg"        = var.rg-network-core
      "team"         = local.teamTag.NET
      "rolloutStage" = local.rolloutStages.Initial
    }
    FirewallFortiGateBLinux = {
      "vm_name"      = var.vm-linux-lcl-FGT-B
      "vm_rg"        = var.rg-network-core
      "team"         = local.teamTag.NET
      "rolloutStage" = local.rolloutStages.Initial
    }
  }
  # 
  # loadbalancer
  # 
  loadbalancer = {
    lb-kubeinternal-blue = {
      "name"                = "KubeInternalBlue"
      "lb_name"             = var.lb-kubeinternal-blue
      "resource_group_name" = coalesce(var.rg-lb-kubeinternal-blue, "rg-aksnodes-blue-${var.region}-${var.env}")
      "threshold"           = var.lb_aks_threshold
    }
    lb-core = {
      "name"                = "CoreInternal"
      "lb_name"             = var.lb-core
      "resource_group_name" = var.rg-network-core
      "threshold"           = var.lb_common_threshold
    }
  }
  # 
  # apim
  # 
  apim_commom = {
    APIM = {
      "apim"    = coalesce(var.apim, "api-pointsbet-${var.region}-${var.env}")
      "rg_apim" = coalesce(var.rg-ai-apim, "rg-apim-${var.region}-${var.env}")
    }
  }
}
