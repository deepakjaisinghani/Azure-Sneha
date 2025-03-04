{
    "definition": {
        "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
        "contentVersion": "1.0.0.0",
        "triggers": {
            "manual": {
                "type": "Request",
                "kind": "Http",
                "inputs": {
                    "schema": {
                        "properties": {
                            "$content": {
                                "type": "string"
                            },
                            "$content-type": {
                                "type": "string"
                            },
                            "$formdata": {
                                "items": {
                                    "properties": {
                                        "key": {
                                            "type": "string"
                                        },
                                        "value": {
                                            "type": "string"
                                        }
                                    },
                                    "required": [
                                        "key",
                                        "value"
                                    ],
                                    "type": "object"
                                },
                                "type": "array"
                            }
                        },
                        "type": "object"
                    }
                }
            }
        },
        "actions": {
            "Check_Bpoint_Flag": {
                "type": "If",
                "expression": {
                    "and": [
                        {
                            "equals": [
                                "@variables('command')",
                                "/pb_enableaubpoint"
                            ]
                        }
                    ]
                },
                "actions": {
                    "Bpoint_Check_Enabled_OR_Disabled": {
                        "type": "If",
                        "expression": {
                            "and": [
                                {
                                    "equals": [
                                        "@variables('bpointflag')",
                                        true
                                    ]
                                }
                            ]
                        },
                        "actions": {
                            "HTTP_14": {
                                "type": "Http",
                                "inputs": {
                                    "uri": "https://hooks.slack.com/services/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",
                                    "method": "POST",
                                    "headers": {
                                        "Content-type": "application/json"
                                    },
                                    "body": {
                                        "parse": "full",
                                        "response_type": "in_channel",
                                        "text": "AU :: BPoint is set to current Deposit Gateway, FatZebra is Disabled by @{variables('user_name')} "
                                    }
                                }
                            },
                            "HTTP_16": {
                                "type": "Http",
                                "inputs": {
                                    "uri": "https://hooks.slack.com/services/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",
                                    "method": "POST",
                                    "headers": {
                                        "Content-type": "application/json"
                                    },
                                    "body": {
                                        "parse": "full",
                                        "response_type": "in_channel",
                                        "text": "AU :: BPoint is set to current Deposit Gateway, FatZebra is Disabled by @{variables('user_name')} "
                                    }
                                },
                                "runAfter": {
                                    "HTTP_14": [
                                        "Succeeded"
                                    ]
                                }
                            }
                        },
                        "else": {
                            "actions": {
                                "HTTP_15": {
                                    "type": "Http",
                                    "inputs": {
                                        "uri": "https://hooks.slack.com/services/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",
                                        "method": "POST",
                                        "headers": {
                                            "Content-type": "application/json"
                                        },
                                        "body": {
                                            "parse": "full",
                                            "response_type": "in_channel",
                                            "text": "AU :: FatZebra is set to current Deposit Gateway, BPoint is Disabled by @{variables('user_name')} "
                                        }
                                    }
                                },
                                "HTTP_17": {
                                    "type": "Http",
                                    "inputs": {
                                        "uri": "https://hooks.slack.com/services/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",
                                        "method": "POST",
                                        "headers": {
                                            "Content-type": "application/json"
                                        },
                                        "body": {
                                            "parse": "full",
                                            "response_type": "in_channel",
                                            "text": "AU :: FatZebra is set to current Deposit Gateway, BPoint is Disabled by @{variables('user_name')} "
                                        }
                                    },
                                    "runAfter": {
                                        "HTTP_15": [
                                            "Succeeded"
                                        ]
                                    }
                                }
                            }
                        },
                        "runAfter": {
                            "HTTP_5": [
                                "Succeeded"
                            ]
                        }
                    },
                    "HTTP_5": {
                        "type": "Http",
                        "inputs": {
                            "uri": "@variables('response_url')",
                            "method": "POST",
                            "headers": {
                                "Content-type": "application/json"
                            },
                            "body": {
                                "parse": "full",
                                "response_type": "in_channel",
                                "text": " Is AU Bpoint enabled set to : @{variables('bpointflag')} by @{variables('user_name')}  "
                            }
                        },
                        "runAfter": {
                            "Update_blob_(V2)_4": [
                                "Succeeded"
                            ]
                        }
                    },
                    "Terminate": {
                        "type": "Terminate",
                        "inputs": {
                            "runStatus": "Succeeded"
                        },
                        "runAfter": {
                            "Bpoint_Check_Enabled_OR_Disabled": [
                                "Succeeded"
                            ]
                        }
                    },
                    "Update_blob_(V2)_4": {
                        "type": "ApiConnection",
                        "inputs": {
                            "host": {
                                "connection": {
                                    "name": "@parameters('$connections')['azureblob_5']['connectionId']"
                                }
                            },
                            "method": "put",
                            "body": "@body('jsonify_bpoint_blob')",
                            "headers": {
                                "ReadFileMetadataFromServer": true
                            },
                            "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('JTJmYnBvaW50JTJmYnBvaW50aGVhbHRo'))}"
                        },
                        "runAfter": {
                            "jsonify_bpoint_blob": [
                                "Succeeded"
                            ]
                        },
                        "metadata": {
                            "JTJmYnBvaW50JTJmYnBvaW50aGVhbHRo": "/bpoint/bpointhealth"
                        }
                    },
                    "compose_bpointblob": {
                        "type": "Compose",
                        "inputs": {
                            "IsAvailable": "@variables('bpointflag')"
                        }
                    },
                    "jsonify_bpoint_blob": {
                        "type": "ParseJson",
                        "inputs": {
                            "content": "@outputs('compose_bpointblob')",
                            "schema": {
                                "properties": {
                                    "IsAvailable": {
                                        "type": "string"
                                    }
                                },
                                "type": "object"
                            }
                        },
                        "runAfter": {
                            "compose_bpointblob": [
                                "Succeeded"
                            ]
                        }
                    }
                },
                "else": {
                    "actions": {}
                },
                "runAfter": {
                    "get_bpointflag": [
                        "Succeeded"
                    ]
                }
            },
            "Condition": {
                "type": "If",
                "expression": {
                    "and": [
                        {
                            "equals": [
                                "@variables('channelid')",
                                "G01C2PGF3K4"
                            ]
                        },
                        {
                            "equals": [
                                "@variables('teamdomain')",
                                "pointsbet"
                            ]
                        },
                        {
                            "equals": [
                                "@variables('teamid')",
                                "T29CFQQ0Z"
                            ]
                        },
                        {
                            "equals": [
                                "@variables('token')",
                                "pN5fVIR7uWx8wVkpnHwR01aV"
                            ]
                        }
                    ]
                },
                "actions": {
                    "Switch_2": {
                        "type": "Switch",
                        "expression": "@variables('command')",
                        "default": {
                            "actions": {}
                        },
                        "cases": {
                            "Case_notification_banner": {
                                "actions": {
                                    "Compose_2": {
                                        "type": "Compose",
                                        "inputs": "@base64ToString(body('Get_blob_content').$content)",
                                        "runAfter": {
                                            "Get_blob_content": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Filter_array_2": {
                                        "type": "Query",
                                        "inputs": {
                                            "from": "@body('Parse_JSON_2')",
                                            "where": "@equals(item()['component'], toLower(variables('component')))"
                                        },
                                        "runAfter": {
                                            "Parse_JSON_2": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "For_each_2": {
                                        "type": "Foreach",
                                        "foreach": "@body('Filter_array_2')",
                                        "actions": {
                                            "Compose_3": {
                                                "type": "Compose",
                                                "inputs": [
                                                    {
                                                        "endTime": "@{addMinutes(utcNow(),120)}",
                                                        "message": "@{items('For_each_2')?['message']}",
                                                        "startTime": "@{addMinutes(utcNow(),60)}"
                                                    }
                                                ]
                                            },
                                            "Parse_JSON_3": {
                                                "type": "ParseJson",
                                                "inputs": {
                                                    "content": "@outputs('Compose_3')",
                                                    "schema": {
                                                        "items": {
                                                            "properties": {
                                                                "endTime": {
                                                                    "type": "string"
                                                                },
                                                                "message": {
                                                                    "type": "string"
                                                                },
                                                                "startTime": {
                                                                    "type": "string"
                                                                }
                                                            },
                                                            "required": [
                                                                "endTime",
                                                                "message",
                                                                "startTime"
                                                            ],
                                                            "type": "object"
                                                        },
                                                        "type": "array"
                                                    }
                                                },
                                                "runAfter": {
                                                    "Compose_3": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            },
                                            "Set_variable_3": {
                                                "type": "SetVariable",
                                                "inputs": {
                                                    "name": "notifyblob",
                                                    "value": "@body('Parse_JSON_3')"
                                                },
                                                "runAfter": {
                                                    "Parse_JSON_3": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            }
                                        },
                                        "runAfter": {
                                            "Filter_array_2": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Get_blob_content": {
                                        "type": "ApiConnection",
                                        "inputs": {
                                            "host": {
                                                "connection": {
                                                    "name": "@parameters('$connections')['azureblob']['connectionId']"
                                                }
                                            },
                                            "method": "get",
                                            "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('JTJmY29udGVudCUyZmNvbW1vbiUyZm5vdGlmaWNhdGlvbi1tZXNzYWdlcy5qc29u'))}/content",
                                            "queries": {
                                                "inferContentType": true
                                            }
                                        },
                                        "metadata": {
                                            "JTJmY29udGVudCUyZmNvbW1vbiUyZm5vdGlmaWNhdGlvbi1tZXNzYWdlcy5qc29u": "/content/common/notification-messages.json"
                                        }
                                    },
                                    "HTTP_6": {
                                        "type": "Http",
                                        "inputs": {
                                            "uri": "@variables('response_url')",
                                            "method": "POST",
                                            "queries": {
                                                "Content-type": "application/json"
                                            },
                                            "body": {
                                                "parse": "full",
                                                "response_type": "in_channel",
                                                "text": "@{variables('region')}-  posted a notification banner successfully by @{variables('user_name')} for @{variables('component')}"
                                            }
                                        },
                                        "runAfter": {
                                            "Switch_3": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Parse_JSON_2": {
                                        "type": "ParseJson",
                                        "inputs": {
                                            "content": "@outputs('Compose_2')",
                                            "schema": {
                                                "items": {
                                                    "properties": {
                                                        "component": {
                                                            "type": "string"
                                                        },
                                                        "message": {
                                                            "type": "string"
                                                        }
                                                    },
                                                    "required": [
                                                        "component",
                                                        "message"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                            }
                                        },
                                        "runAfter": {
                                            "Compose_2": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Switch_3": {
                                        "type": "Switch",
                                        "expression": "@toLower(variables('region'))",
                                        "default": {
                                            "actions": {
                                                "Update_blob_(V2)_6": {
                                                    "type": "ApiConnection",
                                                    "inputs": {
                                                        "host": {
                                                            "connection": {
                                                                "name": "@parameters('$connections')['azureblob']['connectionId']"
                                                            }
                                                        },
                                                        "method": "put",
                                                        "body": "@string(variables('notifyblob'))",
                                                        "headers": {
                                                            "ReadFileMetadataFromServer": true
                                                        },
                                                        "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('/content/',toLower(variables('region')),'/maintenance/notify.json'))}"
                                                    }
                                                }
                                            }
                                        },
                                        "cases": {
                                            "Case": {
                                                "actions": {
                                                    "Update_blob_(V2)_5": {
                                                        "type": "ApiConnection",
                                                        "inputs": {
                                                            "host": {
                                                                "connection": {
                                                                    "name": "@parameters('$connections')['azureblob_2']['connectionId']"
                                                                }
                                                            },
                                                            "method": "put",
                                                            "body": "@string(variables('notifyblob'))",
                                                            "headers": {
                                                                "ReadFileMetadataFromServer": true
                                                            },
                                                            "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('JTJmY29udGVudCUyZmF1JTJmbWFpbnRlbmFuY2UlMmZub3RpZnkuanNvbg=='))}"
                                                        },
                                                        "metadata": {
                                                            "JTJmY29udGVudCUyZmF1JTJmbWFpbnRlbmFuY2UlMmZub3RpZnkuanNvbg==": "/content/au/maintenance/notify.json"
                                                        }
                                                    }
                                                },
                                                "case": "au"
                                            }
                                        },
                                        "runAfter": {
                                            "For_each_2": [
                                                "Succeeded"
                                            ]
                                        }
                                    }
                                },
                                "case": "/pb_website_notify"
                            },
                            "Case_pb_website_mstart": {
                                "actions": {
                                    "Compose_6": {
                                        "type": "Compose",
                                        "inputs": {
                                            "change_reason": "@variables('changeReason')",
                                            "duration": "@outputs('get_duration')",
                                            "end_time": "@outputs('calculate_end_time')",
                                            "id_s": "@variables('region')",
                                            "start_time": "@outputs('get_current_time')"
                                        },
                                        "runAfter": {
                                            "Condition_check_change_reason_for_Incident_Workflows": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Compose_7": {
                                        "type": "Compose",
                                        "inputs": "@union(createArray(outputs('Compose_6')),body('Parse_JSON_8'))",
                                        "runAfter": {
                                            "Parse_JSON_8": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Compose_8": {
                                        "type": "Compose",
                                        "inputs": {
                                            "Maintenance": {
                                                "Region": "@outputs('Compose_7')"
                                            }
                                        },
                                        "runAfter": {
                                            "Compose_7": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Condition_2": {
                                        "type": "If",
                                        "expression": {
                                            "and": [
                                                {
                                                    "not": {
                                                        "equals": [
                                                            "@variables('changeReason')",
                                                            "planned"
                                                        ]
                                                    }
                                                }
                                            ]
                                        },
                                        "actions": {
                                            "Set_variable_4": {
                                                "type": "SetVariable",
                                                "inputs": {
                                                    "name": "message",
                                                    "value": "Due to an unexpected issue, PointsBet is currently unavailable in @{variables('statename')}. Our technology teams are working diligently to remedy the issue and restore service to our users as quickly as possible. We will notify customers as soon as our site and app are back up and fully functioning. Any bets placed prior to this issue will be settled as usual. If you have any further questions, please contact the PointsBet customer service team at service@pointsbet.com"
                                                }
                                            }
                                        },
                                        "else": {
                                            "actions": {
                                                "Set_variable_5": {
                                                    "type": "SetVariable",
                                                    "inputs": {
                                                        "name": "message",
                                                        "value": "PointsBet is currently undergoing planned maintenance. Thank you for your patience as we continue to work on bringing you the top sports betting experience. Any bets placed prior to the maintanence window will be settled as usual."
                                                    }
                                                }
                                            }
                                        },
                                        "runAfter": {
                                            "calculate_end_time": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Condition_check_change_reason_for_Incident_Workflows": {
                                        "type": "If",
                                        "expression": {
                                            "and": [
                                                {
                                                    "equals": [
                                                        "@variables('changeReason')",
                                                        "unplanned"
                                                    ]
                                                }
                                            ]
                                        },
                                        "actions": {
                                            "Filter_array_UpOrDownTime_Incident_Workflows": {
                                                "type": "Query",
                                                "inputs": {
                                                    "from": "@body('Parse_JSON_Get_List_Incident_Workflows')['incident_workflows']",
                                                    "where": "@contains(toUpper(item()?['name']),variables('UpOrDownTime'))"
                                                },
                                                "runAfter": {
                                                    "Parse_JSON_Get_List_Incident_Workflows": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            },
                                            "Filter_array_service_against_region": {
                                                "type": "Query",
                                                "inputs": {
                                                    "from": "@body('Parse_JSON_IncidentWorkflowList')",
                                                    "where": "@equals(item()['Region'], variables('region'))"
                                                },
                                                "runAfter": {
                                                    "Parse_JSON_IncidentWorkflowList": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            },
                                            "For_each_3": {
                                                "type": "Foreach",
                                                "foreach": "@body('Filter_array_service_against_region')",
                                                "actions": {
                                                    "HTTP_Create_An_Incident": {
                                                        "type": "Http",
                                                        "inputs": {
                                                            "uri": "@{variables('pagerdutyapi_baseurl')}/incidents",
                                                            "method": "POST",
                                                            "headers": {
                                                                "Accept": "application/vnd.pagerduty+json;version=2",
                                                                "Authorization": "Token token=aE5tAKTP9PzEpPAbMXav",
                                                                "Content-Type": "application/json",
                                                                "From": "sneha.tulluri@pointsbet.com"
                                                            },
                                                            "body": {
                                                                "incident": {
                                                                    "body": {
                                                                        "details": "Website @{replace(variables('UpOrDownTime'),'-','')}. Incident created by the unplanned outage bot to initiate response play.",
                                                                        "type": "incident_body"
                                                                    },
                                                                    "escalation_policy": {
                                                                        "id": "PNKCVTS",
                                                                        "type": "escalation_policy_reference"
                                                                    },
                                                                    "incident_key": "@{guid()}",
                                                                    "service": {
                                                                        "id": "P68FE3B",
                                                                        "type": "service_reference"
                                                                    },
                                                                    "title": "Website @{replace(variables('UpOrDownTime'),'-','')}. Incident created by the unplanned outage bot to initiate response play.",
                                                                    "type": "incident",
                                                                    "urgency": "high"
                                                                }
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "Parse_JSON_Current_Item": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "HTTP_Post_Incident_Workflows_run": {
                                                        "type": "Http",
                                                        "inputs": {
                                                            "uri": "@{variables('pagerdutyapi_baseurl')}/incident_workflows/@{body('Parse_JSON_Current_Item')?['key']}/instances",
                                                            "method": "POST",
                                                            "headers": {
                                                                "Accept": "application/vnd.pagerduty+json;version=2",
                                                                "Authorization": "Token token=aE5tAKTP9PzEpPAbMXav",
                                                                "Content-Type": "application/json",
                                                                "From": "sneha.tulluri@pointsbet.com"
                                                            },
                                                            "body": {
                                                                "incident_workflow_instance": {
                                                                    "id": "@{body('Parse_JSON_Current_Item')?['key']}",
                                                                    "type": "incident_workflow_instance",
                                                                    "incident": {
                                                                        "id": "@{variables('IncidentId')}",
                                                                        "type": "incident_reference"
                                                                    }
                                                                }
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "Set_variable_IncidentId": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Parse_JSON_Create_An_Incident": {
                                                        "type": "ParseJson",
                                                        "inputs": {
                                                            "content": "@body('HTTP_Create_An_Incident')",
                                                            "schema": {
                                                                "properties": {
                                                                    "incident": {
                                                                        "properties": {
                                                                            "acknowledgements": {
                                                                                "type": "array"
                                                                            },
                                                                            "alert_counts": {
                                                                                "properties": {
                                                                                    "all": {
                                                                                        "type": "integer"
                                                                                    },
                                                                                    "resolved": {
                                                                                        "type": "integer"
                                                                                    },
                                                                                    "triggered": {
                                                                                        "type": "integer"
                                                                                    }
                                                                                },
                                                                                "type": "object"
                                                                            },
                                                                            "alert_grouping": {},
                                                                            "assigned_via": {
                                                                                "type": "string"
                                                                            },
                                                                            "assignments": {
                                                                                "items": {
                                                                                    "properties": {
                                                                                        "assignee": {
                                                                                            "properties": {
                                                                                                "html_url": {
                                                                                                    "type": "string"
                                                                                                },
                                                                                                "id": {
                                                                                                    "type": "string"
                                                                                                },
                                                                                                "self": {
                                                                                                    "type": "string"
                                                                                                },
                                                                                                "summary": {
                                                                                                    "type": "string"
                                                                                                },
                                                                                                "type": {
                                                                                                    "type": "string"
                                                                                                }
                                                                                            },
                                                                                            "type": "object"
                                                                                        },
                                                                                        "at": {
                                                                                            "type": "string"
                                                                                        }
                                                                                    },
                                                                                    "required": [
                                                                                        "at",
                                                                                        "assignee"
                                                                                    ],
                                                                                    "type": "object"
                                                                                },
                                                                                "type": "array"
                                                                            },
                                                                            "basic_alert_grouping": {},
                                                                            "body": {
                                                                                "properties": {
                                                                                    "details": {
                                                                                        "type": "string"
                                                                                    }
                                                                                },
                                                                                "type": "object"
                                                                            },
                                                                            "created_at": {
                                                                                "type": "string"
                                                                            },
                                                                            "description": {
                                                                                "type": "string"
                                                                            },
                                                                            "escalation_policy": {
                                                                                "properties": {
                                                                                    "html_url": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "id": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "self": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "summary": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "type": {
                                                                                        "type": "string"
                                                                                    }
                                                                                },
                                                                                "type": "object"
                                                                            },
                                                                            "first_trigger_log_entry": {
                                                                                "properties": {
                                                                                    "html_url": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "id": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "self": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "summary": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "type": {
                                                                                        "type": "string"
                                                                                    }
                                                                                },
                                                                                "type": "object"
                                                                            },
                                                                            "html_url": {
                                                                                "type": "string"
                                                                            },
                                                                            "id": {
                                                                                "type": "string"
                                                                            },
                                                                            "impacted_services": {
                                                                                "items": {
                                                                                    "properties": {
                                                                                        "html_url": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "id": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "self": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "summary": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "type": {
                                                                                            "type": "string"
                                                                                        }
                                                                                    },
                                                                                    "required": [
                                                                                        "id",
                                                                                        "type",
                                                                                        "summary",
                                                                                        "self",
                                                                                        "html_url"
                                                                                    ],
                                                                                    "type": "object"
                                                                                },
                                                                                "type": "array"
                                                                            },
                                                                            "incident_key": {
                                                                                "type": "string"
                                                                            },
                                                                            "incident_number": {
                                                                                "type": "integer"
                                                                            },
                                                                            "incidents_responders": {
                                                                                "type": "array"
                                                                            },
                                                                            "is_mergeable": {
                                                                                "type": "boolean"
                                                                            },
                                                                            "last_status_change_at": {
                                                                                "type": "string"
                                                                            },
                                                                            "last_status_change_by": {
                                                                                "properties": {
                                                                                    "html_url": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "id": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "self": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "summary": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "type": {
                                                                                        "type": "string"
                                                                                    }
                                                                                },
                                                                                "type": "object"
                                                                            },
                                                                            "pending_actions": {
                                                                                "items": {
                                                                                    "properties": {
                                                                                        "at": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "type": {
                                                                                            "type": "string"
                                                                                        }
                                                                                    },
                                                                                    "required": [
                                                                                        "type",
                                                                                        "at"
                                                                                    ],
                                                                                    "type": "object"
                                                                                },
                                                                                "type": "array"
                                                                            },
                                                                            "priority": {},
                                                                            "responder_requests": {
                                                                                "type": "array"
                                                                            },
                                                                            "self": {
                                                                                "type": "string"
                                                                            },
                                                                            "service": {
                                                                                "properties": {
                                                                                    "html_url": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "id": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "self": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "summary": {
                                                                                        "type": "string"
                                                                                    },
                                                                                    "type": {
                                                                                        "type": "string"
                                                                                    }
                                                                                },
                                                                                "type": "object"
                                                                            },
                                                                            "status": {
                                                                                "type": "string"
                                                                            },
                                                                            "subscriber_requests": {
                                                                                "type": "array"
                                                                            },
                                                                            "summary": {
                                                                                "type": "string"
                                                                            },
                                                                            "teams": {
                                                                                "items": {
                                                                                    "properties": {
                                                                                        "html_url": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "id": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "self": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "summary": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "type": {
                                                                                            "type": "string"
                                                                                        }
                                                                                    },
                                                                                    "required": [
                                                                                        "id",
                                                                                        "type",
                                                                                        "summary",
                                                                                        "self",
                                                                                        "html_url"
                                                                                    ],
                                                                                    "type": "object"
                                                                                },
                                                                                "type": "array"
                                                                            },
                                                                            "title": {
                                                                                "type": "string"
                                                                            },
                                                                            "type": {
                                                                                "type": "string"
                                                                            },
                                                                            "urgency": {
                                                                                "type": "string"
                                                                            }
                                                                        },
                                                                        "type": "object"
                                                                    }
                                                                },
                                                                "type": "object"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "HTTP_Create_An_Incident": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Parse_JSON_Current_Item": {
                                                        "type": "ParseJson",
                                                        "inputs": {
                                                            "content": "@items('For_each_3')",
                                                            "schema": {
                                                                "properties": {
                                                                    "Region": {
                                                                        "type": "string"
                                                                    },
                                                                    "key": {
                                                                        "type": "string"
                                                                    },
                                                                    "serviceId": {
                                                                        "type": "string"
                                                                    }
                                                                },
                                                                "type": "object"
                                                            }
                                                        }
                                                    },
                                                    "Parse_JSON__incident_workflow_run": {
                                                        "type": "ParseJson",
                                                        "inputs": {
                                                            "content": "@body('HTTP_Post_Incident_Workflows_run')",
                                                            "schema": {
                                                                "properties": {
                                                                    "status": {
                                                                        "type": "string"
                                                                    }
                                                                },
                                                                "type": "object"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "HTTP_Post_Incident_Workflows_run": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Set_variable_IncidentId": {
                                                        "type": "SetVariable",
                                                        "inputs": {
                                                            "name": "IncidentId",
                                                            "value": "@{body('Parse_JSON_Create_An_Incident')?['incident']?['id']}"
                                                        },
                                                        "runAfter": {
                                                            "Parse_JSON_Create_An_Incident": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    }
                                                },
                                                "runAfter": {
                                                    "Filter_array_service_against_region": [
                                                        "Succeeded"
                                                    ]
                                                },
                                                "runtimeConfiguration": {
                                                    "concurrency": {
                                                        "repetitions": 1
                                                    }
                                                }
                                            },
                                            "For_each_Filtered_Incident_Workflows": {
                                                "type": "Foreach",
                                                "foreach": "@body('Filter_array_UpOrDownTime_Incident_Workflows')",
                                                "actions": {
                                                    "Append_to_array_variable": {
                                                        "type": "AppendToArrayVariable",
                                                        "inputs": {
                                                            "name": "ResponsePlayList",
                                                            "value": {
                                                                "Region": "@{outputs('Split_Incident_Workflow_Name')?[0]}",
                                                                "key": "@{items('For_each_Filtered_Incident_Workflows')?['id']}",
                                                                "serviceId": "@{if(greater(length(body('Filter_array_ServiceId_based_on_the_region_name')), 0), body('Filter_array_ServiceId_based_on_the_region_name')?[0]['id'], '')}"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "Filter_array_ServiceId_based_on_the_region_name": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Filter_array_ServiceId_based_on_the_region_name": {
                                                        "type": "Query",
                                                        "inputs": {
                                                            "from": "@body('Parse_JSON_Get_Services_List_against_region')?['services']",
                                                            "where": "@startsWith(item()?['name'],outputs('Split_Incident_Workflow_Name')?[0])"
                                                        },
                                                        "runAfter": {
                                                            "Parse_JSON_Get_Services_List_against_region": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "HTTP_Get_Services_List_against_region": {
                                                        "type": "Http",
                                                        "inputs": {
                                                            "uri": "@{variables('pagerdutyapi_baseurl')}/services",
                                                            "method": "GET",
                                                            "headers": {
                                                                "Accept": "application/vnd.pagerduty+json;version=2",
                                                                "Authorization": "Token token=aE5tAKTP9PzEpPAbMXav",
                                                                "Content-Type": "application/json",
                                                                "From": "sneha.tulluri@pointsbet.com"
                                                            },
                                                            "queries": {
                                                                "query": "@{outputs('Split_Incident_Workflow_Name')?[0]}"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "Split_Incident_Workflow_Name": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Parse_JSON_Get_Services_List_against_region": {
                                                        "type": "ParseJson",
                                                        "inputs": {
                                                            "content": "@body('HTTP_Get_Services_List_against_region')",
                                                            "schema": {
                                                                "properties": {
                                                                    "limit": {
                                                                        "type": "integer"
                                                                    },
                                                                    "more": {
                                                                        "type": "boolean"
                                                                    },
                                                                    "offset": {
                                                                        "type": "integer"
                                                                    },
                                                                    "services": {
                                                                        "items": {
                                                                            "properties": {
                                                                                "acknowledgement_timeout": {
                                                                                    "type": [
                                                                                        "integer",
                                                                                        "null"
                                                                                    ]
                                                                                },
                                                                                "addons": {
                                                                                    "type": "array"
                                                                                },
                                                                                "alert_creation": {
                                                                                    "type": "string"
                                                                                },
                                                                                "alert_grouping": {},
                                                                                "alert_grouping_parameters": {
                                                                                    "properties": {
                                                                                        "config": {},
                                                                                        "type": {}
                                                                                    },
                                                                                    "type": "object"
                                                                                },
                                                                                "alert_grouping_timeout": {},
                                                                                "auto_resolve_timeout": {
                                                                                    "type": [
                                                                                        "integer",
                                                                                        "null"
                                                                                    ]
                                                                                },
                                                                                "created_at": {
                                                                                    "type": "string"
                                                                                },
                                                                                "description": {
                                                                                    "type": [
                                                                                        "string",
                                                                                        "null"
                                                                                    ]
                                                                                },
                                                                                "escalation_policy": {
                                                                                    "properties": {
                                                                                        "html_url": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "id": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "self": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "summary": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "type": {
                                                                                            "type": "string"
                                                                                        }
                                                                                    },
                                                                                    "type": "object"
                                                                                },
                                                                                "html_url": {
                                                                                    "type": "string"
                                                                                },
                                                                                "id": {
                                                                                    "type": "string"
                                                                                },
                                                                                "incident_urgency_rule": {
                                                                                    "properties": {
                                                                                        "type": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "urgency": {
                                                                                            "type": "string"
                                                                                        }
                                                                                    },
                                                                                    "type": "object"
                                                                                },
                                                                                "integrations": {
                                                                                    "type": "array"
                                                                                },
                                                                                "last_incident_timestamp": {},
                                                                                "name": {
                                                                                    "type": "string"
                                                                                },
                                                                                "response_play": {
                                                                                    "properties": {
                                                                                        "html_url": {
                                                                                            "type": [
                                                                                                "string",
                                                                                                "null"
                                                                                            ]
                                                                                        },
                                                                                        "id": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "self": {},
                                                                                        "summary": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "type": {
                                                                                            "type": "string"
                                                                                        }
                                                                                    },
                                                                                    "type": [
                                                                                        "object",
                                                                                        "null"
                                                                                    ]
                                                                                },
                                                                                "scheduled_actions": {
                                                                                    "type": "array"
                                                                                },
                                                                                "self": {
                                                                                    "type": "string"
                                                                                },
                                                                                "status": {
                                                                                    "type": "string"
                                                                                },
                                                                                "summary": {
                                                                                    "type": "string"
                                                                                },
                                                                                "support_hours": {},
                                                                                "teams": {
                                                                                    "items": {
                                                                                        "properties": {
                                                                                            "html_url": {
                                                                                                "type": "string"
                                                                                            },
                                                                                            "id": {
                                                                                                "type": "string"
                                                                                            },
                                                                                            "self": {
                                                                                                "type": "string"
                                                                                            },
                                                                                            "summary": {
                                                                                                "type": "string"
                                                                                            },
                                                                                            "type": {
                                                                                                "type": "string"
                                                                                            }
                                                                                        },
                                                                                        "required": [
                                                                                            "id",
                                                                                            "type",
                                                                                            "summary",
                                                                                            "self",
                                                                                            "html_url"
                                                                                        ],
                                                                                        "type": "object"
                                                                                    },
                                                                                    "type": "array"
                                                                                },
                                                                                "type": {
                                                                                    "type": "string"
                                                                                },
                                                                                "updated_at": {
                                                                                    "type": "string"
                                                                                }
                                                                            },
                                                                            "required": [
                                                                                "id",
                                                                                "name",
                                                                                "created_at",
                                                                                "updated_at",
                                                                                "status",
                                                                                "teams",
                                                                                "alert_creation",
                                                                                "addons",
                                                                                "scheduled_actions",
                                                                                "support_hours",
                                                                                "last_incident_timestamp",
                                                                                "escalation_policy",
                                                                                "incident_urgency_rule",
                                                                                "alert_grouping",
                                                                                "alert_grouping_timeout",
                                                                                "alert_grouping_parameters",
                                                                                "integrations",
                                                                                "type",
                                                                                "summary",
                                                                                "self",
                                                                                "html_url"
                                                                            ],
                                                                            "type": "object"
                                                                        },
                                                                        "type": "array"
                                                                    },
                                                                    "total": {}
                                                                },
                                                                "type": "object"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "HTTP_Get_Services_List_against_region": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Split_Incident_Workflow_Name": {
                                                        "type": "Compose",
                                                        "inputs": "@split(items('For_each_Filtered_Incident_Workflows')?['name'],'-')"
                                                    }
                                                },
                                                "runAfter": {
                                                    "Filter_array_UpOrDownTime_Incident_Workflows": [
                                                        "Succeeded"
                                                    ]
                                                },
                                                "runtimeConfiguration": {
                                                    "concurrency": {
                                                        "repetitions": 1
                                                    }
                                                }
                                            },
                                            "HTTP_12": {
                                                "type": "Http",
                                                "inputs": {
                                                    "uri": "@variables('response_url')",
                                                    "method": "POST",
                                                    "headers": {
                                                        "Content-type": "application/json"
                                                    },
                                                    "body": {
                                                        "parse": "full",
                                                        "response_type": "in_channel",
                                                        "text": "Stakeholders SMS Sent Successfully"
                                                    }
                                                },
                                                "runAfter": {
                                                    "For_each_3": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            },
                                            "HTTP_13": {
                                                "type": "Http",
                                                "inputs": {
                                                    "uri": "@variables('response_url')",
                                                    "method": "POST",
                                                    "headers": {
                                                        "Content-type": "application/json"
                                                    },
                                                    "body": {
                                                        "parse": "full",
                                                        "response_type": "in_channel",
                                                        "text": "Error - PagerDuty Service is in maintenance, so an incident could not be created to send response play."
                                                    }
                                                },
                                                "runAfter": {
                                                    "HTTP_12": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            },
                                            "HTTP_Get_List_of_Incident_Workflows": {
                                                "type": "Http",
                                                "inputs": {
                                                    "uri": "@{variables('pagerdutyapi_baseurl')}/incident_workflows",
                                                    "method": "GET",
                                                    "headers": {
                                                        "Accept": "application/vnd.pagerduty+json;version=2",
                                                        "Authorization": "Token token=aE5tAKTP9PzEpPAbMXav",
                                                        "Content-Type": "application/json",
                                                        "From": "sneha.tulluri@pointsbet.com"
                                                    }
                                                },
                                                "runAfter": {
                                                    "Set_variable_UpOrDownTime": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            },
                                            "Parse_JSON_Get_List_Incident_Workflows": {
                                                "type": "ParseJson",
                                                "inputs": {
                                                    "content": "@body('HTTP_Get_List_of_Incident_Workflows')",
                                                    "schema": {
                                                        "properties": {
                                                            "incident_workflows": {
                                                                "type": "array",
                                                                "items": {
                                                                    "type": "object",
                                                                    "properties": {
                                                                        "id": {
                                                                            "type": "string"
                                                                        },
                                                                        "name": {
                                                                            "type": "string"
                                                                        },
                                                                        "summary": {
                                                                            "type": "string"
                                                                        },
                                                                        "description": {
                                                                            "type": [
                                                                                "string",
                                                                                "null"
                                                                            ]
                                                                        },
                                                                        "type": {
                                                                            "type": "string"
                                                                        },
                                                                        "created_at": {
                                                                            "type": "string",
                                                                            "format": "date-time"
                                                                        },
                                                                        "self": {
                                                                            "type": "string"
                                                                        },
                                                                        "html_url": {
                                                                            "type": "string"
                                                                        }
                                                                    },
                                                                    "required": [
                                                                        "id",
                                                                        "name",
                                                                        "summary",
                                                                        "type",
                                                                        "created_at",
                                                                        "self",
                                                                        "html_url"
                                                                    ]
                                                                }
                                                            },
                                                            "limit": {
                                                                "type": "integer"
                                                            },
                                                            "offset": {
                                                                "type": "integer"
                                                            },
                                                            "more": {
                                                                "type": "boolean"
                                                            }
                                                        },
                                                        "required": [
                                                            "incident_workflows",
                                                            "limit",
                                                            "offset",
                                                            "more"
                                                        ]
                                                    }
                                                },
                                                "runAfter": {
                                                    "HTTP_Get_List_of_Incident_Workflows": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            },
                                            "Parse_JSON_IncidentWorkflowList": {
                                                "type": "ParseJson",
                                                "inputs": {
                                                    "content": "@variables('ResponsePlayList')",
                                                    "schema": {
                                                        "items": {
                                                            "properties": {
                                                                "Region": {
                                                                    "type": "string"
                                                                },
                                                                "key": {
                                                                    "type": "string"
                                                                },
                                                                "serviceId": {
                                                                    "type": "string"
                                                                }
                                                            },
                                                            "required": [
                                                                "Region",
                                                                "key",
                                                                "serviceId"
                                                            ],
                                                            "type": "object"
                                                        },
                                                        "type": "array"
                                                    }
                                                },
                                                "runAfter": {
                                                    "For_each_Filtered_Incident_Workflows": [
                                                        "Succeeded"
                                                    ]
                                                }
                                            },
                                            "Set_variable_UpOrDownTime": {
                                                "type": "SetVariable",
                                                "inputs": {
                                                    "name": "UpOrDownTime",
                                                    "value": "@{if(equals(outputs('split_text_into_array')[1],'0'),'-UP-', '-DOWN-')}"
                                                }
                                            }
                                        },
                                        "else": {
                                            "actions": {}
                                        },
                                        "runAfter": {
                                            "Switch_1": [
                                                "Succeeded",
                                                "Failed",
                                                "TimedOut",
                                                "Skipped"
                                            ]
                                        }
                                    },
                                    "Get_blob_content_(V2)": {
                                        "type": "ApiConnection",
                                        "inputs": {
                                            "host": {
                                                "connection": {
                                                    "name": "@parameters('$connections')['azureblob_6']['connectionId']"
                                                }
                                            },
                                            "method": "get",
                                            "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('JTJmY29udGVudCUyZm1haW50LXRpbWVzLmpzb24='))}/content"
                                        },
                                        "runAfter": {
                                            "Compose_6": [
                                                "Succeeded"
                                            ]
                                        },
                                        "metadata": {
                                            "JTJmY29udGVudCUyZm1haW50LXRpbWVzLmpzb24=": "/content/maint-times.json"
                                        }
                                    },
                                    "Parse_JSON_7": {
                                        "type": "ParseJson",
                                        "inputs": {
                                            "content": "@variables('getblobcontent')",
                                            "schema": {
                                                "properties": {
                                                    "Maintenance": {
                                                        "properties": {
                                                            "Region": {
                                                                "type": "array"
                                                            }
                                                        },
                                                        "type": "object"
                                                    }
                                                },
                                                "type": "object"
                                            }
                                        },
                                        "runAfter": {
                                            "Set_blobcontent_var": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Parse_JSON_8": {
                                        "type": "ParseJson",
                                        "inputs": {
                                            "content": "@body('Parse_JSON_7')?['Maintenance']?['Region']",
                                            "schema": {
                                                "type": "array"
                                            }
                                        },
                                        "runAfter": {
                                            "Parse_JSON_7": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Set_blobcontent_var": {
                                        "type": "SetVariable",
                                        "inputs": {
                                            "name": "getblobcontent",
                                            "value": "@{concat(body('Get_blob_content_(V2)'),'')}"
                                        },
                                        "runAfter": {
                                            "Get_blob_content_(V2)": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Switch": {
                                        "type": "Switch",
                                        "expression": "@variables('region')",
                                        "default": {
                                            "actions": {
                                                "Condition_3": {
                                                    "type": "If",
                                                    "expression": {
                                                        "and": [
                                                            {
                                                                "endsWith": [
                                                                    "@variables('region')",
                                                                    "all"
                                                                ]
                                                            }
                                                        ]
                                                    },
                                                    "actions": {
                                                        "Compose": {
                                                            "type": "Compose",
                                                            "inputs": "@split(variables('region'),'-')"
                                                        },
                                                        "Compose_5": {
                                                            "type": "Compose",
                                                            "inputs": [
                                                                {
                                                                    "endTime": "@{outputs('calculate_end_time')}",
                                                                    "message": "@{variables('message')}",
                                                                    "startTime": "@{outputs('get_current_time')}"
                                                                }
                                                            ],
                                                            "runAfter": {
                                                                "Condition_6": [
                                                                    "Succeeded"
                                                                ]
                                                            }
                                                        },
                                                        "Condition_6": {
                                                            "type": "If",
                                                            "expression": {
                                                                "and": [
                                                                    {
                                                                        "equals": [
                                                                            "@variables('changeReason')",
                                                                            "planned"
                                                                        ]
                                                                    }
                                                                ]
                                                            },
                                                            "actions": {
                                                                "NJ_Casino": {
                                                                    "type": "SetVariable",
                                                                    "inputs": {
                                                                        "name": "message",
                                                                        "value": "PointsBet Casino is currently undergoing planned maintenance. Thank you for your patience as we continue to work on bringing you the top casino experience. Deposits and withdrawals will not be available during this time."
                                                                    }
                                                                }
                                                            },
                                                            "else": {
                                                                "actions": {
                                                                    "Set_variable_6": {
                                                                        "type": "SetVariable",
                                                                        "inputs": {
                                                                            "name": "message",
                                                                            "value": "Due to unforeseen circumstances, our Casino site is currently down for maintenance. We apologize for any inconvenience and appreciate your patience as we work to resolve this issue."
                                                                        }
                                                                    }
                                                                }
                                                            },
                                                            "runAfter": {
                                                                "Update_blob_(V2)": [
                                                                    "Succeeded"
                                                                ]
                                                            }
                                                        },
                                                        "Parse_JSON_6": {
                                                            "type": "ParseJson",
                                                            "inputs": {
                                                                "content": "@outputs('Compose_5')",
                                                                "schema": {
                                                                    "items": {
                                                                        "properties": {
                                                                            "endTime": {
                                                                                "type": "string"
                                                                            },
                                                                            "message": {
                                                                                "type": "string"
                                                                            },
                                                                            "startTime": {
                                                                                "type": "string"
                                                                            }
                                                                        },
                                                                        "required": [
                                                                            "startTime",
                                                                            "endTime",
                                                                            "message"
                                                                        ],
                                                                        "type": "object"
                                                                    },
                                                                    "type": "array"
                                                                }
                                                            },
                                                            "runAfter": {
                                                                "Compose_5": [
                                                                    "Succeeded"
                                                                ]
                                                            }
                                                        },
                                                        "Set_variable_2": {
                                                            "type": "SetVariable",
                                                            "inputs": {
                                                                "name": "region",
                                                                "value": "@{toLower(first(outputs('Compose')))}"
                                                            },
                                                            "runAfter": {
                                                                "Compose": [
                                                                    "Succeeded"
                                                                ]
                                                            }
                                                        },
                                                        "Update_blob_(V2)": {
                                                            "type": "ApiConnection",
                                                            "inputs": {
                                                                "host": {
                                                                    "connection": {
                                                                        "name": "@parameters('$connections')['azureblob']['connectionId']"
                                                                    }
                                                                },
                                                                "method": "put",
                                                                "body": "@body('covert_blob_content_to_JSON')",
                                                                "headers": {
                                                                    "ReadFileMetadataFromServer": true
                                                                },
                                                                "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('/content/',variables('region'),'/maintenance/kill.json'))}"
                                                            },
                                                            "runAfter": {
                                                                "Set_variable_2": [
                                                                    "Succeeded"
                                                                ]
                                                            }
                                                        },
                                                        "Update_blob_(V2)_2": {
                                                            "type": "ApiConnection",
                                                            "inputs": {
                                                                "host": {
                                                                    "connection": {
                                                                        "name": "@parameters('$connections')['azureblob']['connectionId']"
                                                                    }
                                                                },
                                                                "method": "put",
                                                                "body": "@body('Parse_JSON_6')",
                                                                "headers": {
                                                                    "ReadFileMetadataFromServer": true
                                                                },
                                                                "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('/content/',variables('region'),'-casino/maintenance/kill.json'))}"
                                                            },
                                                            "runAfter": {
                                                                "Parse_JSON_6": [
                                                                    "Succeeded"
                                                                ]
                                                            }
                                                        }
                                                    },
                                                    "else": {
                                                        "actions": {
                                                            "Update_blob_(V2)_3": {
                                                                "type": "ApiConnection",
                                                                "inputs": {
                                                                    "host": {
                                                                        "connection": {
                                                                            "name": "@parameters('$connections')['azureblob']['connectionId']"
                                                                        }
                                                                    },
                                                                    "method": "put",
                                                                    "body": "@body('covert_blob_content_to_JSON')",
                                                                    "headers": {
                                                                        "ReadFileMetadataFromServer": true
                                                                    },
                                                                    "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('/content/',toLower(variables('region')),'/maintenance/kill.json'))}"
                                                                }
                                                            }
                                                        }
                                                    }
                                                },
                                                "HTTP_2": {
                                                    "type": "Http",
                                                    "inputs": {
                                                        "uri": "@variables('response_url')",
                                                        "method": "POST",
                                                        "headers": {
                                                            "Content-type": "application/json"
                                                        },
                                                        "body": {
                                                            "parse": "full",
                                                            "response_type": "in_channel",
                                                            "text": "@{variables('region')}- Maintenance put on site successfully by @{variables('user_name')} till @{outputs('calculate_end_time')} UTC"
                                                        }
                                                    },
                                                    "runAfter": {
                                                        "Condition_3": [
                                                            "Succeeded"
                                                        ]
                                                    }
                                                },
                                                "HTTP_4": {
                                                    "type": "Http",
                                                    "inputs": {
                                                        "uri": "@variables('response_url')",
                                                        "method": "POST",
                                                        "headers": {
                                                            "Content-type": "application/json"
                                                        },
                                                        "body": {
                                                            "parse": "full",
                                                            "response_type": "in_channel",
                                                            "text": " Maintenace page setup for @{variables('region')} did not work, Check Logic apps for the detailed error. command executed by  @{variables('user_name')}"
                                                        }
                                                    },
                                                    "runAfter": {
                                                        "HTTP_2": [
                                                            "Skipped",
                                                            "Failed"
                                                        ]
                                                    }
                                                }
                                            }
                                        },
                                        "cases": {
                                            "Case_2": {
                                                "actions": {
                                                    "HTTP_10": {
                                                        "type": "Http",
                                                        "inputs": {
                                                            "uri": "@variables('response_url')",
                                                            "method": "POST",
                                                            "headers": {
                                                                "Content-type": "application/json"
                                                            },
                                                            "body": {
                                                                "parse": "full",
                                                                "response_type": "in_channel",
                                                                "text": " Maintenace page setup for @{variables('region')} did not work, Check Logic apps for the detailed error. command executed by  @{variables('user_name')}"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "HTTP_7": [
                                                                "Failed"
                                                            ]
                                                        }
                                                    },
                                                    "HTTP_7": {
                                                        "type": "Http",
                                                        "inputs": {
                                                            "uri": "@variables('response_url')",
                                                            "method": "POST",
                                                            "headers": {
                                                                "Content-type": "application/json"
                                                            },
                                                            "body": {
                                                                "parse": "full",
                                                                "response_type": "in_channel",
                                                                "text": "@{variables('region')}- Maintenance put on site successfully by @{variables('user_name')} till @{outputs('calculate_end_time')} UTC"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "Update_blob_(V2)_7": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Update_blob_(V2)_7": {
                                                        "type": "ApiConnection",
                                                        "inputs": {
                                                            "host": {
                                                                "connection": {
                                                                    "name": "@parameters('$connections')['azureblob_3']['connectionId']"
                                                                }
                                                            },
                                                            "method": "put",
                                                            "body": "@body('covert_blob_content_to_JSON')",
                                                            "headers": {
                                                                "ReadFileMetadataFromServer": true
                                                            },
                                                            "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('JTJmY29udGVudCUyZm9uJTJmbWFpbnRlbmFuY2UlMmZraWxsLmpzb24='))}"
                                                        },
                                                        "metadata": {
                                                            "JTJmY29udGVudCUyZm9uJTJmbWFpbnRlbmFuY2UlMmZraWxsLmpzb24=": "/content/on/maintenance/kill.json"
                                                        }
                                                    }
                                                },
                                                "case": "ON"
                                            },
                                            "Case-1": {
                                                "actions": {
                                                    "AU_Blob_content": {
                                                        "type": "Compose",
                                                        "inputs": [
                                                            {
                                                                "endTime": "@{outputs('calculate_end_time')}",
                                                                "message": "@{variables('message')}",
                                                                "startTime": "@{outputs('get_current_time')}"
                                                            }
                                                        ],
                                                        "runAfter": {
                                                            "Condition_4": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Condition_4": {
                                                        "type": "If",
                                                        "expression": {
                                                            "and": [
                                                                {
                                                                    "not": {
                                                                        "equals": [
                                                                            "@variables('changeReason')",
                                                                            "planned"
                                                                        ]
                                                                    }
                                                                }
                                                            ]
                                                        },
                                                        "actions": {
                                                            "AU_message": {
                                                                "type": "SetVariable",
                                                                "inputs": {
                                                                    "name": "message",
                                                                    "value": "Due to an unexpected issue on our site, PointsBet is currently unavailable. Our teams are working to restore services as fast as possible. We will notify customers as soon as the system is back up and running."
                                                                }
                                                            }
                                                        },
                                                        "else": {
                                                            "actions": {
                                                                "Set_variable_7": {
                                                                    "type": "SetVariable",
                                                                    "inputs": {
                                                                        "name": "message",
                                                                        "value": "PointsBet is currently undergoing planned maintenance. Thank you for your patience as we continue to work on bringing you the top sports betting experience. Any bets placed prior to the maintanence window will be settled as usual."
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    },
                                                    "HTTP_3": {
                                                        "type": "Http",
                                                        "inputs": {
                                                            "uri": "@variables('response_url')",
                                                            "method": "POST",
                                                            "headers": {
                                                                "Content-type": "application/json"
                                                            },
                                                            "body": {
                                                                "parse": "full",
                                                                "response_type": "in_channel",
                                                                "text": "@{variables('region')}- Maintenance put on site successfully by @{variables('user_name')} till @{outputs('calculate_end_time')} UTC"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "Update_blob_2": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Parse_JSON_5": {
                                                        "type": "ParseJson",
                                                        "inputs": {
                                                            "content": "@outputs('AU_Blob_content')",
                                                            "schema": {
                                                                "items": {
                                                                    "properties": {
                                                                        "endTime": {
                                                                            "type": "string"
                                                                        },
                                                                        "message": {
                                                                            "type": "string"
                                                                        },
                                                                        "startTime": {
                                                                            "type": "string"
                                                                        }
                                                                    },
                                                                    "required": [
                                                                        "startTime",
                                                                        "endTime",
                                                                        "message"
                                                                    ],
                                                                    "type": "object"
                                                                },
                                                                "type": "array"
                                                            }
                                                        },
                                                        "runAfter": {
                                                            "AU_Blob_content": [
                                                                "Succeeded"
                                                            ]
                                                        }
                                                    },
                                                    "Update_blob_2": {
                                                        "type": "ApiConnection",
                                                        "inputs": {
                                                            "host": {
                                                                "connection": {
                                                                    "name": "@parameters('$connections')['azureblob_2']['connectionId']"
                                                                }
                                                            },
                                                            "method": "put",
                                                            "body": "@body('Parse_JSON_5')",
                                                            "path": "/datasets/default/files/@{encodeURIComponent(encodeURIComponent('JTJmY29udGVudCUyZmF1JTJmbWFpbnRlbmFuY2UlMmZraWxsLmpzb24='))}"
                                                        },
                                                        "runAfter": {
                                                            "Parse_JSON_5": [
                                                                "Succeeded"
                                                            ]
                                                        },
                                                        "metadata": {
                                                            "JTJmY29udGVudCUyZmF1JTJmbWFpbnRlbmFuY2UlMmZraWxsLmpzb24=": "/content/au/maintenance/kill.json"
                                                        }
                                                    }
                                                },
                                                "case": "AU"
                                            }
                                        },
                                        "runAfter": {
                                            "covert_blob_content_to_JSON": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Update_blob_(V2)_9": {
                                        "type": "ApiConnection",
                                        "inputs": {
                                            "host": {
                                                "connection": {
                                                    "name": "@parameters('$connections')['azureblob_6']['connectionId']"
                                                }
                                            },
                                            "method": "put",
                                            "body": "@outputs('Compose_8')",
                                            "headers": {
                                                "ReadFileMetadataFromServer": true
                                            },
                                            "path": "/v2/datasets/@{encodeURIComponent(encodeURIComponent('AccountNameFromSettings'))}/files/@{encodeURIComponent(encodeURIComponent('JTJmY29udGVudCUyZm1haW50LXRpbWVzLmpzb24='))}"
                                        },
                                        "runAfter": {
                                            "Compose_8": [
                                                "Succeeded"
                                            ]
                                        },
                                        "metadata": {
                                            "JTJmY29udGVudCUyZm1haW50LXRpbWVzLmpzb24=": "/content/maint-times.json"
                                        }
                                    },
                                    "calculate_end_time": {
                                        "type": "Compose",
                                        "inputs": "@addMinutes(outputs('get_current_time'),outputs('convert_duration_to_integer'))",
                                        "runAfter": {
                                            "get_current_time": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "compose_blob": {
                                        "type": "Compose",
                                        "inputs": [
                                            {
                                                "endTime": "@{outputs('calculate_end_time')}",
                                                "message": "@{variables('message')}",
                                                "startTime": "@{outputs('get_current_time')}"
                                            }
                                        ],
                                        "runAfter": {
                                            "Condition_2": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "convert_duration_to_integer": {
                                        "type": "Compose",
                                        "inputs": "@int(outputs('get_duration'))",
                                        "runAfter": {
                                            "set_changereason": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "covert_blob_content_to_JSON": {
                                        "type": "ParseJson",
                                        "inputs": {
                                            "content": "@outputs('compose_blob')",
                                            "schema": {
                                                "items": {
                                                    "properties": {
                                                        "endTime": {
                                                            "type": "string"
                                                        },
                                                        "message": {
                                                            "type": "string"
                                                        },
                                                        "startTime": {
                                                            "type": "string"
                                                        }
                                                    },
                                                    "required": [
                                                        "startTime",
                                                        "endTime",
                                                        "message"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                            }
                                        },
                                        "runAfter": {
                                            "compose_blob": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "get_current_time": {
                                        "type": "Compose",
                                        "inputs": "@utcNow()",
                                        "runAfter": {
                                            "convert_duration_to_integer": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "get_duration": {
                                        "type": "Compose",
                                        "inputs": "@outputs('split_text_into_array')[1]"
                                    },
                                    "set_changereason": {
                                        "type": "SetVariable",
                                        "inputs": {
                                            "name": "changeReason",
                                            "value": "@{outputs('split_text_into_array')[2]}"
                                        },
                                        "runAfter": {
                                            "get_duration": [
                                                "Succeeded"
                                            ]
                                        }
                                    },
                                    "Switch_1": {
                                        "type": "Switch",
                                        "expression": "@variables('region')",
                                        "default": {
                                            "actions": {}
                                        },
                                        "cases": {
                                            "AU": {
                                                "actions": {
                                                    "Condition_(Check_if_duration_is__not_0)": {
                                                        "type": "If",
                                                        "expression": {
                                                            "and": [
                                                                {
                                                                    "not": {
                                                                        "equals": [
                                                                            "@int(outputs('get_duration'))",
                                                                            0
                                                                        ]
                                                                    }
                                                                }
                                                            ]
                                                        },
                                                        "actions": {
                                                            "HTTP_11": {
                                                                "type": "Http",
                                                                "inputs": {
                                                                    "uri": "@variables('response_url')",
                                                                    "method": "POST",
                                                                    "headers": {
                                                                        "Content-type": "application/json"
                                                                    },
                                                                    "body": {
                                                                        "parse": "full",
                                                                        "response_type": "in_channel",
                                                                        "text": "responsible-gambling, auth-server and betty scaled to 0."
                                                                    }
                                                                },
                                                                "runAfter": {
                                                                    "Stop_Login_Services_-_AU": [
                                                                        "Succeeded"
                                                                    ]
                                                                }
                                                            },
                                                            "Stop_Login_Services_-_AU": {
                                                                "type": "Http",
                                                                "inputs": {
                                                                    "uri": "http://23.96.176.231/api/v2/job_templates/28/launch/",
                                                                    "method": "POST",
                                                                    "headers": {
                                                                        "Content-type": "application/json"
                                                                    },
                                                                    "body": {
                                                                        "extra_vars": {
                                                                            "ORC": "localhost",
                                                                            "command_name": "/pb_service_login_au",
                                                                            "pb_env": "prod",
                                                                            "region": "@{substring(variables('region'),0,2)}",
                                                                            "svc_state": "stopped"
                                                                        }
                                                                    },
                                                                    "authentication": {
                                                                        "password": "P0intsb3t@wx",
                                                                        "type": "Basic",
                                                                        "username": "admin"
                                                                    }
                                                                }
                                                            }
                                                        },
                                                        "else": {
                                                            "actions": {
                                                                "Start_Login_Services_-_AU": {
                                                                    "type": "Http",
                                                                    "inputs": {
                                                                        "uri": "http://23.96.176.231/api/v2/job_templates/28/launch/",
                                                                        "method": "POST",
                                                                        "headers": {
                                                                            "Content-type": "application/json"
                                                                        },
                                                                        "body": {
                                                                            "extra_vars": {
                                                                                "ORC": "localhost",
                                                                                "command_name": "/pb_service_login_au",
                                                                                "pb_env": "prod",
                                                                                "region": "@{substring(variables('region'),0,2)}",
                                                                                "svc_state": "started"
                                                                            }
                                                                        },
                                                                        "authentication": {
                                                                            "type": "Basic",
                                                                            "username": "admin",
                                                                            "password": "P0intsb3t@wx"
                                                                        }
                                                                    },
                                                                    "runtimeConfiguration": {
                                                                        "contentTransfer": {
                                                                            "transferMode": "Chunked"
                                                                        }
                                                                    }
                                                                },
                                                                "HTTP_8": {
                                                                    "type": "Http",
                                                                    "inputs": {
                                                                        "uri": "@variables('response_url')",
                                                                        "method": "POST",
                                                                        "headers": {
                                                                            "Content-type": "application/json"
                                                                        },
                                                                        "body": {
                                                                            "parse": "full",
                                                                            "response_type": "in_channel",
                                                                            "text": "responsible-gambling, auth-server and betty scaled up."
                                                                        }
                                                                    },
                                                                    "runAfter": {
                                                                        "Start_Login_Services_-_AU": [
                                                                            "Succeeded"
                                                                        ]
                                                                    },
                                                                    "runtimeConfiguration": {
                                                                        "contentTransfer": {
                                                                            "transferMode": "Chunked"
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                },
                                                "case": "AU"
                                            },
                                            "ON": {
                                                "actions": {
                                                    "Condition_1": {
                                                        "type": "If",
                                                        "expression": {
                                                            "and": [
                                                                {
                                                                    "not": {
                                                                        "equals": [
                                                                            "@int(outputs('get_duration'))",
                                                                            0
                                                                        ]
                                                                    }
                                                                }
                                                            ]
                                                        },
                                                        "actions": {
                                                            "Stop_Login_Services": {
                                                                "type": "Http",
                                                                "inputs": {
                                                                    "uri": "http://23.96.176.231/api/v2/job_templates/28/launch/",
                                                                    "method": "POST",
                                                                    "headers": {
                                                                        "Content-type": "application/json"
                                                                    },
                                                                    "body": {
                                                                        "extra_vars": {
                                                                            "ORC": "localhost",
                                                                            "command_name": "/pb_service_login",
                                                                            "pb_env": "prod",
                                                                            "region": "@{substring(variables('region'),0,2)}",
                                                                            "svc_state": "stopped"
                                                                        }
                                                                    },
                                                                    "authentication": {
                                                                        "password": "P0intsb3t@wx",
                                                                        "type": "Basic",
                                                                        "username": "admin"
                                                                    }
                                                                }
                                                            },
                                                            "HTTP_20": {
                                                                "type": "Http",
                                                                "inputs": {
                                                                    "uri": "@variables('response_url')",
                                                                    "method": "POST",
                                                                    "headers": {
                                                                        "Content-type": "application/json"
                                                                    },
                                                                    "body": {
                                                                        "parse": "full",
                                                                        "response_type": "in_channel",
                                                                        "text": "responsible-gambling, global-account-engine to 0."
                                                                    }
                                                                },
                                                                "runAfter": {
                                                                    "Stop_Login_Services": [
                                                                        "Succeeded"
                                                                    ]
                                                                }
                                                            }
                                                        },
                                                        "else": {
                                                            "actions": {
                                                                "Start_Login_Services_-_ON_": {
                                                                    "type": "Http",
                                                                    "inputs": {
                                                                        "uri": "http://23.96.176.231/api/v2/job_templates/28/launch",
                                                                        "method": "POST",
                                                                        "headers": {
                                                                            "Content-type": "application/json"
                                                                        },
                                                                        "body": {
                                                                            "extra_vars": {
                                                                                "ORC": "localhost",
                                                                                "command_name": "/pb_service_login",
                                                                                "pb_env": "prod",
                                                                                "region": "@{substring(variables('region'),0,2)}",
                                                                                "svc_state": "started"
                                                                            }
                                                                        },
                                                                        "authentication": {
                                                                            "type": "Basic",
                                                                            "username": "admin",
                                                                            "password": "P0intsb3t@wx"
                                                                        }
                                                                    },
                                                                    "runtimeConfiguration": {
                                                                        "contentTransfer": {
                                                                            "transferMode": "Chunked"
                                                                        }
                                                                    }
                                                                },
                                                                "HTTP_18": {
                                                                    "type": "Http",
                                                                    "inputs": {
                                                                        "uri": "@variables('response_url')",
                                                                        "method": "POST",
                                                                        "headers": {
                                                                            "Content-type": "application/json"
                                                                        },
                                                                        "body": {
                                                                            "parse": "full",
                                                                            "response_type": "in_channel",
                                                                            "text": "responsible-gambling, auth-server and betty scaled up."
                                                                        }
                                                                    },
                                                                    "runAfter": {
                                                                        "Start_Login_Services_-_ON_": [
                                                                            "Succeeded"
                                                                        ]
                                                                    },
                                                                    "runtimeConfiguration": {
                                                                        "contentTransfer": {
                                                                            "transferMode": "Chunked"
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                },
                                                "case": "ON"
                                            }
                                        },
                                        "runAfter": {
                                            "Switch": [
                                                "Succeeded"
                                            ]
                                        }
                                    }
                                },
                                "case": "/pb_website_mstart"
                            }
                        }
                    }
                },
                "else": {
                    "actions": {
                        "HTTP": {
                            "type": "Http",
                            "inputs": {
                                "uri": "@variables('response_url')",
                                "method": "POST",
                                "headers": {
                                    "Content-type": "application/json"
                                },
                                "body": {
                                    "parse": "full",
                                    "response_type": "in_channel",
                                    "text": "sorry @{variables('user_name')},command not allowed from this channel"
                                }
                            }
                        }
                    }
                },
                "runAfter": {
                    "For_each": [
                        "Succeeded",
                        "Failed"
                    ]
                }
            },
            "For_each": {
                "type": "Foreach",
                "foreach": "@body('filter_state_name')",
                "actions": {
                    "Set_variable": {
                        "type": "SetVariable",
                        "inputs": {
                            "name": "statename",
                            "value": "@items('For_each')?['StateName']"
                        }
                    }
                },
                "runAfter": {
                    "Initialize_variable_2": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_changeReason": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "changeReason",
                            "type": "string"
                        }
                    ]
                },
                "runAfter": {
                    "Initialize_notifyblob_message": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_message": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "message",
                            "type": "string",
                            "value": "The system is currently unavailable and undergoing a planned upgrade."
                        }
                    ]
                },
                "runAfter": {
                    "usastateslist": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_notifyblob_message": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "notifyblob",
                            "type": "array"
                        }
                    ]
                },
                "runAfter": {
                    "Initialize_variable": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_variable": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "component",
                            "type": "string",
                            "value": "@{toLower(outputs('split_text_into_array')[1])}"
                        }
                    ]
                },
                "runAfter": {
                    "Check_Bpoint_Flag": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_variable_-_region": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "region",
                            "type": "string",
                            "value": "@{outputs('split_text_into_array')[0]}"
                        }
                    ]
                },
                "runAfter": {
                    "split_text_into_array": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_variable_2": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "getblobcontent",
                            "type": "string"
                        }
                    ]
                },
                "runAfter": {
                    "filter_state_name": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_variable_3": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "statename",
                            "type": "string"
                        }
                    ]
                },
                "runAfter": {
                    "Initialize_changeReason": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_variable_Array_ResponsePlayList": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "ResponsePlayList",
                            "type": "array"
                        }
                    ]
                },
                "runAfter": {
                    "Initialize_variable_incidentid": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_variable_UpOrDownTime": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "UpOrDownTime",
                            "type": "string"
                        }
                    ]
                },
                "runAfter": {
                    "Initialize_variable_Array_ResponsePlayList": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_variable_incidentid": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "IncidentId",
                            "type": "string"
                        }
                    ]
                },
                "runAfter": {
                    "Initialize_variable_pagerdutyapi_baseurl": [
                        "Succeeded"
                    ]
                }
            },
            "Initialize_variable_pagerdutyapi_baseurl": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "pagerdutyapi_baseurl",
                            "type": "string",
                            "value": "https://api.pagerduty.com"
                        }
                    ]
                },
                "runAfter": {
                    "get_region": [
                        "Succeeded"
                    ]
                }
            },
            "Parse_JSON": {
                "type": "ParseJson",
                "inputs": {
                    "content": "@triggerBody()?['$formdata']",
                    "schema": {
                        "items": {
                            "properties": {
                                "key": {
                                    "type": "string"
                                },
                                "value": {
                                    "type": "string"
                                }
                            },
                            "required": [
                                "key",
                                "value"
                            ],
                            "type": "object"
                        },
                        "type": "array"
                    }
                },
                "runAfter": {
                    "Response": [
                        "Succeeded"
                    ]
                }
            },
            "Response": {
                "type": "Response",
                "kind": "Http",
                "inputs": {
                    "statusCode": 200
                },
                "runAfter": {}
            },
            "Security_-_Extract_channel_id": {
                "type": "Query",
                "inputs": {
                    "from": "@body('Parse_JSON')",
                    "where": "@equals(item()?['key'], 'channel_id')"
                },
                "runAfter": {
                    "set_teamdomain": [
                        "Succeeded"
                    ]
                }
            },
            "Security_-_Extract_team_domain": {
                "type": "Query",
                "inputs": {
                    "from": "@body('Parse_JSON')",
                    "where": "@equals(item()?['key'], 'team_domain')"
                },
                "runAfter": {
                    "security_set_teamid": [
                        "Succeeded"
                    ]
                }
            },
            "Security_-_Extract_team_id": {
                "type": "Query",
                "inputs": {
                    "from": "@body('Parse_JSON')",
                    "where": "@equals(item()?['key'], 'team_id')"
                },
                "runAfter": {
                    "set_command": [
                        "Succeeded"
                    ]
                }
            },
            "Security_-_Extract_token": {
                "type": "Query",
                "inputs": {
                    "from": "@body('Parse_JSON')",
                    "where": "@equals(item()['key'], 'token')"
                },
                "runAfter": {
                    "Parse_JSON": [
                        "Succeeded"
                    ]
                }
            },
            "extract_command": {
                "type": "Query",
                "inputs": {
                    "from": "@body('Parse_JSON')",
                    "where": "@equals(item()['key'], 'command')"
                },
                "runAfter": {
                    "set_username": [
                        "Succeeded"
                    ]
                }
            },
            "extract_username": {
                "type": "Query",
                "inputs": {
                    "from": "@body('Parse_JSON')",
                    "where": "@equals(item()['key'], 'user_name')"
                },
                "runAfter": {
                    "security_set_token": [
                        "Succeeded"
                    ]
                }
            },
            "filter_state_name": {
                "type": "Query",
                "inputs": {
                    "from": "@body('parse_json_usastateslist')",
                    "where": "@equals(item()['PostalCode'], variables('region'))"
                },
                "runAfter": {
                    "parse_json_usastateslist": [
                        "Succeeded"
                    ]
                }
            },
            "get_bpointflag": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "bpointflag",
                            "type": "string",
                            "value": "@{outputs('split_text_into_array')[0]}"
                        }
                    ]
                },
                "runAfter": {
                    "Initialize_variable_UpOrDownTime": [
                        "Succeeded"
                    ]
                }
            },
            "get_region": {
                "type": "Compose",
                "inputs": "@outputs('split_text_into_array')[0]",
                "runAfter": {
                    "Initialize_variable_-_region": [
                        "Succeeded"
                    ]
                }
            },
            "get_response_url": {
                "type": "Query",
                "inputs": {
                    "from": "@body('Parse_JSON')",
                    "where": "@equals(item()['key'], 'response_url')"
                },
                "runAfter": {
                    "set_channel_name": [
                        "Succeeded"
                    ]
                }
            },
            "get_text_from_slack": {
                "type": "Query",
                "inputs": {
                    "from": "@body('Parse_JSON')",
                    "where": "@equals(item()['key'], 'text')"
                },
                "runAfter": {
                    "set_response_url": [
                        "Succeeded"
                    ]
                }
            },
            "parse_json_usastateslist": {
                "type": "ParseJson",
                "inputs": {
                    "content": "@outputs('usastateslist')",
                    "schema": {
                        "items": {
                            "properties": {
                                "PostalCode": {
                                    "type": "string"
                                },
                                "StateName": {
                                    "type": "string"
                                }
                            },
                            "required": [
                                "StateName",
                                "PostalCode"
                            ],
                            "type": "object"
                        },
                        "type": "array"
                    }
                },
                "runAfter": {
                    "Initialize_message": [
                        "Succeeded"
                    ]
                }
            },
            "security_set_teamid": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "teamid",
                            "type": "string",
                            "value": "@{first(body('Security_-_Extract_team_id'))?['value']}"
                        }
                    ]
                },
                "runAfter": {
                    "Security_-_Extract_team_id": [
                        "Succeeded"
                    ]
                }
            },
            "security_set_token": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "token",
                            "type": "string",
                            "value": "@{first(body('Security_-_Extract_token'))?['value']}"
                        }
                    ]
                },
                "runAfter": {
                    "Security_-_Extract_token": [
                        "Succeeded"
                    ]
                }
            },
            "set_channel_name": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "channelid",
                            "type": "string",
                            "value": "@{first(body('Security_-_Extract_channel_id'))?['value']}"
                        }
                    ]
                },
                "runAfter": {
                    "Security_-_Extract_channel_id": [
                        "Succeeded"
                    ]
                }
            },
            "set_command": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "command",
                            "type": "string",
                            "value": "@{first(body('extract_command'))?['value']}"
                        }
                    ]
                },
                "runAfter": {
                    "extract_command": [
                        "Succeeded"
                    ]
                }
            },
            "set_response_url": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "response_url",
                            "type": "string",
                            "value": "@{first(body('get_response_url'))?['value']}"
                        }
                    ]
                },
                "runAfter": {
                    "get_response_url": [
                        "Succeeded"
                    ]
                }
            },
            "set_teamdomain": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "teamdomain",
                            "type": "string",
                            "value": "@{first(body('Security_-_Extract_team_domain'))?['value']}"
                        }
                    ]
                },
                "runAfter": {
                    "Security_-_Extract_team_domain": [
                        "Succeeded"
                    ]
                }
            },
            "set_text_from_slack": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "text",
                            "type": "string",
                            "value": "@{first(body('get_text_from_slack'))?['value']}"
                        }
                    ]
                },
                "runAfter": {
                    "get_text_from_slack": [
                        "Succeeded"
                    ]
                }
            },
            "set_username": {
                "type": "InitializeVariable",
                "inputs": {
                    "variables": [
                        {
                            "name": "user_name",
                            "type": "string",
                            "value": "@{first(body('extract_username'))?['value']}"
                        }
                    ]
                },
                "runAfter": {
                    "extract_username": [
                        "Succeeded"
                    ]
                }
            },
            "split_text_into_array": {
                "type": "Compose",
                "inputs": "@split(variables('text'),' ')",
                "runAfter": {
                    "set_text_from_slack": [
                        "Succeeded"
                    ]
                }
            },
            "usastateslist": {
                "type": "Compose",
                "inputs": [
                    {
                        "PostalCode": "AL",
                        "StateName": "Alabama"
                    },
                    {
                        "PostalCode": "AK",
                        "StateName": "Alaska"
                    },
                    {
                        "PostalCode": "AZ",
                        "StateName": "Arizona"
                    },
                    {
                        "PostalCode": "AR",
                        "StateName": "Arkansas"
                    },
                    {
                        "PostalCode": "CA",
                        "StateName": "California"
                    },
                    {
                        "PostalCode": "CO",
                        "StateName": "Colorado"
                    },
                    {
                        "PostalCode": "CT",
                        "StateName": "Connecticut"
                    },
                    {
                        "PostalCode": "DE",
                        "StateName": "Delaware"
                    },
                    {
                        "PostalCode": "DC",
                        "StateName": "District of Columbia"
                    },
                    {
                        "PostalCode": "FL",
                        "StateName": "Florida"
                    },
                    {
                        "PostalCode": "GA",
                        "StateName": "Georgia"
                    },
                    {
                        "PostalCode": "HI",
                        "StateName": "Hawaii"
                    },
                    {
                        "PostalCode": "ID",
                        "StateName": "Idaho"
                    },
                    {
                        "PostalCode": "IL",
                        "StateName": "Illinois"
                    },
                    {
                        "PostalCode": "IN",
                        "StateName": "Indiana"
                    },
                    {
                        "PostalCode": "IA",
                        "StateName": "Iowa"
                    },
                    {
                        "PostalCode": "KS",
                        "StateName": "Kansas"
                    },
                    {
                        "PostalCode": "KY",
                        "StateName": "Kentucky"
                    },
                    {
                        "PostalCode": "LA",
                        "StateName": "Louisiana"
                    },
                    {
                        "PostalCode": "ME",
                        "StateName": "Maine"
                    },
                    {
                        "PostalCode": "MD",
                        "StateName": "Maryland"
                    },
                    {
                        "PostalCode": "MA",
                        "StateName": "Massachusetts"
                    },
                    {
                        "PostalCode": "MI",
                        "StateName": "Michigan"
                    },
                    {
                        "PostalCode": "MN",
                        "StateName": "Minnesota"
                    },
                    {
                        "PostalCode": "MS",
                        "StateName": "Mississippi"
                    },
                    {
                        "PostalCode": "MO",
                        "StateName": "Missouri"
                    },
                    {
                        "PostalCode": "MT",
                        "StateName": "Montana"
                    },
                    {
                        "PostalCode": "NE",
                        "StateName": "Nebraska"
                    },
                    {
                        "PostalCode": "NV",
                        "StateName": "Nevada"
                    },
                    {
                        "PostalCode": "NH",
                        "StateName": "New Hampshire"
                    },
                    {
                        "PostalCode": "NJ",
                        "StateName": "New Jersey"
                    },
                    {
                        "PostalCode": "NM",
                        "StateName": "New Mexico"
                    },
                    {
                        "PostalCode": "NY",
                        "StateName": "New York"
                    },
                    {
                        "PostalCode": "NC",
                        "StateName": "North Carolina"
                    },
                    {
                        "PostalCode": "ND",
                        "StateName": "North Dakota"
                    },
                    {
                        "PostalCode": "OH",
                        "StateName": "Ohio"
                    },
                    {
                        "PostalCode": "OK",
                        "StateName": "Oklahoma"
                    },
                    {
                        "PostalCode": "OR",
                        "StateName": "Oregon"
                    },
                    {
                        "PostalCode": "PA",
                        "StateName": "Pennsylvania"
                    },
                    {
                        "PostalCode": "RI",
                        "StateName": "Rhode Island"
                    },
                    {
                        "PostalCode": "SC",
                        "StateName": "South Carolina"
                    },
                    {
                        "PostalCode": "SD",
                        "StateName": "South Dakota"
                    },
                    {
                        "PostalCode": "TN",
                        "StateName": "Tennessee"
                    },
                    {
                        "PostalCode": "TX",
                        "StateName": "Texas"
                    },
                    {
                        "PostalCode": "UT",
                        "StateName": "Utah"
                    },
                    {
                        "PostalCode": "VT",
                        "StateName": "Vermont"
                    },
                    {
                        "PostalCode": "VA",
                        "StateName": "Virginia"
                    },
                    {
                        "PostalCode": "WA",
                        "StateName": "Washington"
                    },
                    {
                        "PostalCode": "WV",
                        "StateName": "West Virginia"
                    },
                    {
                        "PostalCode": "WI",
                        "StateName": "Wisconsin"
                    },
                    {
                        "PostalCode": "WY",
                        "StateName": "Wyoming"
                    },
                    {
                        "PostalCode": "AS",
                        "StateName": "American Samoa"
                    },
                    {
                        "PostalCode": "GU",
                        "StateName": "Guam"
                    },
                    {
                        "PostalCode": "MH",
                        "StateName": "Marshall Islands"
                    },
                    {
                        "PostalCode": "FM",
                        "StateName": "Micronesia"
                    },
                    {
                        "PostalCode": "MP",
                        "StateName": "Northern Mariana Islands"
                    },
                    {
                        "PostalCode": "PW",
                        "StateName": "Palau"
                    },
                    {
                        "PostalCode": "PR",
                        "StateName": "Puerto Rico"
                    },
                    {
                        "PostalCode": "VI",
                        "StateName": "Virgin Islands"
                    },
                    {
                        "PostalCode": "ON",
                        "StateName": "Ontario"
                    },
                    {
                        "PostalCode": "NJ-All",
                        "StateName": "New Jersey"
                    },
                    {
                        "PostalCode": "NJ-Casino",
                        "StateName": "New Jersey"
                    }
                ],
                "runAfter": {
                    "Initialize_variable_3": [
                        "Succeeded"
                    ]
                }
            }
        },
        "outputs": {},
        "parameters": {
            "awx_admin_pass": {
                "defaultValue": "default",
                "type": "String"
            },
            "$connections": {
                "type": "Object",
                "defaultValue": {}
            }
        }
    },
    "parameters": {
        "$connections": {
            "type": "Object",
            "value": {
                "azureblob_5": {
                    "id": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/providers/Microsoft.Web/locations/australiaeast/managedApis/azureblob",
                    "connectionId": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/resourceGroups/rg_maint-page-prod/providers/Microsoft.Web/connections/azureblob-9",
                    "connectionName": "azureblob-9"
                },
                "azureblob": {
                    "id": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/providers/Microsoft.Web/locations/australiaeast/managedApis/azureblob",
                    "connectionId": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/resourceGroups/rg_maint-page-prod/providers/Microsoft.Web/connections/azureblob-12",
                    "connectionName": "azureblob-12"
                },
                "azureblob_2": {
                    "id": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/providers/Microsoft.Web/locations/australiaeast/managedApis/azureblob",
                    "connectionId": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/resourceGroups/rg_maint-page-prod/providers/Microsoft.Web/connections/azureblob-13",
                    "connectionName": "azureblob-13"
                },
                "azureblob_6": {
                    "id": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/providers/Microsoft.Web/locations/australiaeast/managedApis/azureblob",
                    "connectionId": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/resourceGroups/rg_maint-page-prod/providers/Microsoft.Web/connections/azureblob-3",
                    "connectionName": "azureblob-3"
                },
                "azureblob_3": {
                    "id": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/providers/Microsoft.Web/locations/australiaeast/managedApis/azureblob",
                    "connectionId": "/subscriptions/42e2b66b-57da-4400-b06a-e9110a8d3440/resourceGroups/rg_maint-page-prod/providers/Microsoft.Web/connections/azureblob-17",
                    "connectionName": "azureblob-17"
                }
            }
        }
    }
}
