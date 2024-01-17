{
    "lenses": {
      "0": {
        "order": 0,
        "parts": {
          "0": {
            "position": {
              "x": 0,
              "y": 0,
              "colSpan": 4,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [],
              "type": "Extension/Microsoft_AAD_IAM/PartType/OrganizationIdentityPart"
            }
          },
          "1": {
            "position": {
              "x": 4,
              "y": 0,
              "colSpan": 2,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [],
              "type": "Extension/Microsoft_AAD_IAM/PartType/UserManagementSummaryPart"
            }
          },
          "2": {
            "position": {
              "x": 6,
              "y": 0,
              "colSpan": 2,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [],
              "type": "Extension/Microsoft_AAD_IAM/PartType/ActiveDirectoryQuickTasksPart"
            }
          },
          "3": {
            "position": {
              "x": 8,
              "y": 0,
              "colSpan": 4,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [
                {
                  "name": "userObjectId",
                  "isOptional": true
                },
                {
                  "name": "startDate",
                  "isOptional": true
                },
                {
                  "name": "endDate",
                  "isOptional": true
                },
                {
                  "name": "fromAppsTile",
                  "isOptional": true
                }
              ],
              "type": "Extension/Microsoft_AAD_IAM/PartType/UsersActivitySummaryReportPart"
            }
          },
          "4": {
            "position": {
              "x": 0,
              "y": 2,
              "colSpan": 6,
              "rowSpan": 4
            },
            "metadata": {
              "inputs": [
                {
                  "name": "ComponentId",
                  "value": "Azure Active Directory",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "value": null,
                  "isOptional": true
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "/subscriptions/${subscription_id}/resourceGroups/${rg_name}/providers/Microsoft.OperationalInsights/workspaces/${la_name}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "community-Workbooks/Azure Active Directory/SignIns",
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.aadiam/tenant",
                  "isOptional": true
                },
                {
                  "name": "PinName",
                  "value": "Sign-ins",
                  "isOptional": true
                },
                {
                  "name": "StepSettings",
                  "value": "{\"version\":\"KqlItem/1.0\",\"query\":\"let data = SigninLogs\\r\\n| extend AppDisplayName = iff(AppDisplayName == '', 'Unknown', AppDisplayName)\\r\\n|where AppDisplayName in ({Apps}) or '*' in ({Apps})\\r\\n|where UserDisplayName in ({Users}) or '*' in ({Users})\\r\\n| extend Country = iff(LocationDetails.countryOrRegion == '', 'Unknown country', tostring(LocationDetails.countryOrRegion))\\r\\n| extend City = iff(LocationDetails.city == '', 'Unknown city', tostring(LocationDetails.city))\\r\\n| extend errorCode = Status.errorCode\\r\\n| extend SigninStatus = case(errorCode == 0, \\\"Success\\\", errorCode == 50058, \\\"Pending user action\\\",errorCode == 50140, \\\"Pending user action\\\", errorCode == 51006, \\\"Pending user action\\\", errorCode == 50059, \\\"Pending user action\\\",errorCode == 65001, \\\"Pending user action\\\", errorCode == 52004, \\\"Pending user action\\\", errorCode == 50055, \\\"Pending user action\\\", errorCode == 50144, \\\"Pending user action\\\", errorCode == 50072, \\\"Pending user action\\\", errorCode == 50074, \\\"Pending user action\\\", errorCode == 16000, \\\"Pending user action\\\", errorCode == 16001, \\\"Pending user action\\\", errorCode == 16003, \\\"Pending user action\\\", errorCode == 50127, \\\"Pending user action\\\", errorCode == 50125, \\\"Pending user action\\\", errorCode == 50129, \\\"Pending user action\\\", errorCode == 50143, \\\"Pending user action\\\", errorCode == 81010, \\\"Pending user action\\\", errorCode == 81014, \\\"Pending user action\\\", errorCode == 81012 ,\\\"Pending user action\\\", \\\"Failure\\\")\\r\\n| where SigninStatus == '{SigninStatus}' or '{SigninStatus}' == '*' or '{SigninStatus}' == 'All Sign-ins';\\r\\nlet countryData = data\\r\\n| summarize TotalCount = count(), SuccessCount = countif(SigninStatus == \\\"Success\\\"), FailureCount = countif(SigninStatus == \\\"Failure\\\"), InterruptCount = countif(SigninStatus == \\\"Pending user action\\\") by Country\\r\\n| join kind=inner\\r\\n(\\r\\n    data\\r\\n   | make-series Trend = count() default = 0 on TimeGenerated in range({TimeRange:start}, {TimeRange:end}, {TimeRange:grain}) by  Country\\r\\n    | project-away TimeGenerated\\r\\n)\\r\\non Country\\r\\n| project Country, TotalCount, SuccessCount,FailureCount,InterruptCount,  Trend\\r\\n| order by TotalCount desc, Country asc;\\r\\ndata\\r\\n| summarize TotalCount = count(), SuccessCount = countif(SigninStatus == \\\"Success\\\"), FailureCount = countif(SigninStatus == \\\"Failure\\\"), InterruptCount = countif(SigninStatus == \\\"Pending user action\\\") by Country, City\\r\\n| join kind=inner\\r\\n(\\r\\n    data    \\r\\n    | make-series Trend = count() default = 0 on TimeGenerated in range({TimeRange:start}, {TimeRange:end}, {TimeRange:grain}) by Country, City\\r\\n    | project-away TimeGenerated\\r\\n)\\r\\non Country, City\\r\\n| order by TotalCount desc, Country asc\\r\\n| project Country, City,TotalCount, SuccessCount,FailureCount,InterruptCount, Trend\\r\\n| join kind=inner\\r\\n(\\r\\n    countryData\\r\\n)\\r\\non Country\\r\\n| project Id = City, Name = City, Type = 'City', ['Sign-in Count'] = TotalCount, Trend, ['Failure Count'] = FailureCount, ['Interrupt Count'] = InterruptCount, ['Success Rate'] = 1.0 * SuccessCount / TotalCount, ParentId = Country\\r\\n| union (countryData\\r\\n| project Id = Country, Name = Country, Type = 'Country', ['Sign-in Count'] = TotalCount, Trend, ['Failure Count'] = FailureCount, ['Interrupt Count'] = InterruptCount, ['Success Rate'] = 1.0 * SuccessCount / TotalCount, ParentId = 'root')\\r\\n| order by ['Sign-in Count'] desc, Name asc\",\"size\":1,\"showAnalytics\":true,\"title\":\"Sign-ins by Location\",\"timeContextFromParameter\":\"TimeRange\",\"exportParameterName\":\"LocationDetail\",\"exportDefaultValue\":\"{ \\\"Name\\\":\\\"\\\", \\\"Type\\\":\\\"*\\\"}\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"visualization\":\"table\",\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"Id\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}},{\"columnMatch\":\"Type\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}},{\"columnMatch\":\"Sign-in Count\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"palette\":\"blue\",\"showIcon\":true},\"numberFormat\":{\"unit\":17,\"options\":{\"style\":\"decimal\"}}},{\"columnMatch\":\"Trend\",\"formatter\":9,\"formatOptions\":{\"min\":0,\"palette\":\"blue\",\"showIcon\":true}},{\"columnMatch\":\"Failure Count|Interrupt Count\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"palette\":\"orange\",\"showIcon\":true},\"numberFormat\":{\"unit\":17,\"options\":{\"style\":\"decimal\"}}},{\"columnMatch\":\"Success Rate\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true},\"numberFormat\":{\"unit\":0,\"options\":{\"style\":\"percent\"}}},{\"columnMatch\":\"ParentId\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}}],\"filter\":true,\"hierarchySettings\":{\"idColumn\":\"Id\",\"parentColumn\":\"ParentId\",\"treeType\":0,\"expanderColumn\":\"Name\",\"expandTopLevel\":false}}}",
                  "isOptional": true
                },
                {
                  "name": "ParameterValues",
                  "value": {
                    "TimeRange": {
                      "type": 4,
                      "value": {
                        "durationMs": 86400000
                      },
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "Last 24 hours",
                      "displayName": "TimeRange",
                      "formattedValue": "Last 24 hours"
                    },
                    "Apps": {
                      "type": 2,
                      "value": [
                        "*"
                      ],
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "All",
                      "displayName": "Apps",
                      "specialValue": [
                        "value::all"
                      ],
                      "formattedValue": "'*'"
                    },
                    "Users": {
                      "type": 2,
                      "value": [
                        "*"
                      ],
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "All",
                      "displayName": "Users",
                      "specialValue": [
                        "value::all"
                      ],
                      "formattedValue": "'*'"
                    },
                    "SigninStatus": {
                      "value": "*",
                      "formattedValue": "*",
                      "labelValue": "*",
                      "type": 1
                    }
                  },
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                }
              ],
              "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart"
            }
          },
          "5": {
            "position": {
              "x": 6,
              "y": 2,
              "colSpan": 6,
              "rowSpan": 4
            },
            "metadata": {
              "inputs": [
                {
                  "name": "ComponentId",
                  "value": "Azure Active Directory",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "value": null,
                  "isOptional": true
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "/subscriptions/${subscription_id}/resourceGroups/${rg_name}/providers/Microsoft.OperationalInsights/workspaces/${la_name}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "community-Workbooks/Azure Active Directory/SignIns",
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.aadiam/tenant",
                  "isOptional": true
                },
                {
                  "name": "PinName",
                  "value": "Sign-ins",
                  "isOptional": true
                },
                {
                  "name": "StepSettings",
                  "value": "{\"version\":\"KqlItem/1.0\",\"query\":\"let data = SigninLogs\\r\\n|where AppDisplayName in ({Apps}) or '*' in ({Apps})\\r\\n|where UserDisplayName in ({Users}) or '*' in ({Users})\\r\\n| extend errorCode = Status.errorCode\\r\\n| extend SigninStatus = case(errorCode == 0, \\\"Success\\\", errorCode == 50058, \\\"Pending user action\\\",errorCode == 50140, \\\"Pending user action\\\", errorCode == 51006, \\\"Pending user action\\\", errorCode == 50059, \\\"Pending user action\\\",errorCode == 65001, \\\"Pending user action\\\", errorCode == 52004, \\\"Pending user action\\\", errorCode == 50055, \\\"Pending user action\\\", errorCode == 50144, \\\"Pending user action\\\", errorCode == 50072, \\\"Pending user action\\\", errorCode == 50074, \\\"Pending user action\\\", errorCode == 16000, \\\"Pending user action\\\", errorCode == 16001, \\\"Pending user action\\\", errorCode == 16003, \\\"Pending user action\\\", errorCode == 50127, \\\"Pending user action\\\", errorCode == 50125, \\\"Pending user action\\\", errorCode == 50129, \\\"Pending user action\\\", errorCode == 50143, \\\"Pending user action\\\", errorCode == 81010, \\\"Pending user action\\\", errorCode == 81014, \\\"Pending user action\\\", errorCode == 81012 ,\\\"Pending user action\\\", \\\"Failure\\\")\\r\\n| where SigninStatus == '{SigninStatus}' or '{SigninStatus}' == '*' or '{SigninStatus}' == 'All Sign-ins';\\r\\nlet appData = data\\r\\n| summarize TotalCount = count(), SuccessCount = countif(SigninStatus == \\\"Success\\\"), FailureCount = countif(SigninStatus == \\\"Failure\\\"), InterruptCount = countif(SigninStatus == \\\"Pending user action\\\") by Os = tostring(DeviceDetail.operatingSystem)\\r\\n| where Os != ''\\r\\n| join kind=inner (data\\r\\n    | make-series Trend = count() default = 0 on TimeGenerated in range({TimeRange:start}, {TimeRange:end}, {TimeRange:grain}) by Os = tostring(DeviceDetail.operatingSystem)\\r\\n    | project-away TimeGenerated) on Os\\r\\n| order by TotalCount desc, Os asc\\r\\n| project Os, TotalCount, SuccessCount, FailureCount, InterruptCount, Trend\\r\\n| serialize Id = row_number();\\r\\ndata\\r\\n| summarize TotalCount = count(), SuccessCount = countif(SigninStatus == \\\"Success\\\"), FailureCount = countif(SigninStatus == \\\"Failure\\\"), InterruptCount = countif(SigninStatus == \\\"Pending user action\\\") by Os = tostring(DeviceDetail.operatingSystem), Browser = tostring(DeviceDetail.browser)\\r\\n| join kind=inner (data\\r\\n    | make-series Trend = count() default = 0 on TimeGenerated in range({TimeRange:start}, {TimeRange:end}, {TimeRange:grain}) by Os = tostring(DeviceDetail.operatingSystem), Browser = tostring(DeviceDetail.browser)\\r\\n    | project-away TimeGenerated) on Os, Browser\\r\\n| order by TotalCount desc, Os asc\\r\\n| project Os, Browser, TotalCount, SuccessCount, FailureCount, InterruptCount, Trend\\r\\n| serialize Id = row_number(1000000)\\r\\n| join kind=inner (appData) on Os\\r\\n| project Id, Name = Browser, Type = 'Browser', ['Sign-in Count'] = TotalCount, Trend, ['Failure Count'] = FailureCount, ['Interrupt Count'] = InterruptCount, ['Success Rate'] = 1.0 * SuccessCount / TotalCount, ParentId = Id1\\r\\n| union (appData \\r\\n    | project Id, Name = Os, Type = 'Operating System', ['Sign-in Count'] = TotalCount, Trend, ['Failure Count'] = FailureCount, ['Interrupt Count'] = InterruptCount, ['Success Rate'] = 1.0 * SuccessCount / TotalCount, ParentId = -1)\\r\\n| order by ['Sign-in Count'] desc, Name asc\",\"size\":1,\"showAnalytics\":true,\"title\":\"Sign-ins by Device\",\"timeContextFromParameter\":\"TimeRange\",\"exportParameterName\":\"DeviceDetail\",\"exportDefaultValue\":\"{ \\\"Name\\\":\\\"\\\", \\\"Type\\\":\\\"*\\\"}\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"visualization\":\"table\",\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"Id\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}},{\"columnMatch\":\"Type\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}},{\"columnMatch\":\"Sign-in Count\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"palette\":\"blue\",\"showIcon\":true},\"numberFormat\":{\"unit\":17,\"options\":{\"style\":\"decimal\"}}},{\"columnMatch\":\"Trend\",\"formatter\":9,\"formatOptions\":{\"min\":0,\"palette\":\"blue\",\"showIcon\":true},\"numberFormat\":{\"unit\":17,\"options\":{\"style\":\"decimal\"}}},{\"columnMatch\":\"Failure Count|Interrupt Count\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"palette\":\"orange\",\"showIcon\":true},\"numberFormat\":{\"unit\":17,\"options\":{\"style\":\"decimal\"}}},{\"columnMatch\":\"Success Rate\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true},\"numberFormat\":{\"unit\":0,\"options\":{\"style\":\"percent\"}}},{\"columnMatch\":\"ParentId\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}}],\"filter\":true,\"hierarchySettings\":{\"idColumn\":\"Id\",\"parentColumn\":\"ParentId\",\"treeType\":0,\"expanderColumn\":\"Name\",\"expandTopLevel\":false}}}",
                  "isOptional": true
                },
                {
                  "name": "ParameterValues",
                  "value": {
                    "TimeRange": {
                      "type": 4,
                      "value": {
                        "durationMs": 86400000
                      },
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "Last 24 hours",
                      "displayName": "TimeRange",
                      "formattedValue": "Last 24 hours"
                    },
                    "Apps": {
                      "type": 2,
                      "value": [
                        "*"
                      ],
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "All",
                      "displayName": "Apps",
                      "specialValue": [
                        "value::all"
                      ],
                      "formattedValue": "'*'"
                    },
                    "Users": {
                      "type": 2,
                      "value": [
                        "*"
                      ],
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "All",
                      "displayName": "Users",
                      "specialValue": [
                        "value::all"
                      ],
                      "formattedValue": "'*'"
                    },
                    "SigninStatus": {
                      "value": "*",
                      "formattedValue": "*",
                      "labelValue": "*",
                      "type": 1
                    },
                    "LocationDetail": {
                      "value": "{ \"Name\":\"\", \"Type\":\"*\"}",
                      "formattedValue": "{ \"Name\":\"\", \"Type\":\"*\"}",
                      "labelValue": "{ \"Name\":\"\", \"Type\":\"*\"}",
                      "type": 1
                    }
                  },
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                }
              ],
              "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart"
            }
          },
          "6": {
            "position": {
              "x": 0,
              "y": 6,
              "colSpan": 12,
              "rowSpan": 5
            },
            "metadata": {
              "inputs": [
                {
                  "name": "ComponentId",
                  "value": "Azure Active Directory",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "value": null,
                  "isOptional": true
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "/subscriptions/${subscription_id}/resourceGroups/${rg_name}/providers/Microsoft.OperationalInsights/workspaces/${la_name}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "community-Workbooks/Azure Active Directory/SignIns",
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.aadiam/tenant",
                  "isOptional": true
                },
                {
                  "name": "PinName",
                  "value": "Sign-ins",
                  "isOptional": true
                },
                {
                  "name": "StepSettings",
                  "value": "{\"version\":\"KqlItem/1.0\",\"query\":\"SigninLogs\\r\\n|extend ParseLocation = parse_json(LocationDetails)\\r\\n| extend Country = iff(ParseLocation.countryOrRegion == '', 'Unknown', tostring(ParseLocation.countryOrRegion))\\r\\n| extend City = iff(ParseLocation.city == '', 'Unknown', tostring(ParseLocation.city))\\r\\n| extend State = iff(ParseLocation.state == '', 'Unknown', tostring(ParseLocation.state))\\r\\n| extend GeoCoord = ParseLocation.geoCoordinates\\r\\n| extend ParseGeoCoord = parse_json(GeoCoord)\\r\\n| extend Latitude = ParseGeoCoord.latitude\\r\\n| extend Longitude = ParseGeoCoord.longitude\\r\\n| project UserDisplayName, Location, Latitude, Longitude, City, State, Country\\r\\n| summarize Count = count() by City, State, Country\",\"size\":2,\"showAnalytics\":true,\"title\":\"Sign-ins Heatmap\",\"timeContextFromParameter\":\"TimeRange\",\"exportParameterName\":\"LocationDetail\",\"exportDefaultValue\":\"{ \\\"Name\\\":\\\"\\\", \\\"Type\\\":\\\"*\\\"}\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"visualization\":\"map\",\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"Id\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}},{\"columnMatch\":\"Type\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}},{\"columnMatch\":\"Sign-in Count\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"palette\":\"blue\",\"showIcon\":true},\"numberFormat\":{\"unit\":17,\"options\":{\"style\":\"decimal\"}}},{\"columnMatch\":\"Trend\",\"formatter\":9,\"formatOptions\":{\"min\":0,\"palette\":\"blue\",\"showIcon\":true}},{\"columnMatch\":\"Failure Count|Interrupt Count\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"palette\":\"orange\",\"showIcon\":true},\"numberFormat\":{\"unit\":17,\"options\":{\"style\":\"decimal\"}}},{\"columnMatch\":\"Success Rate\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true},\"numberFormat\":{\"unit\":0,\"options\":{\"style\":\"percent\"}}},{\"columnMatch\":\"ParentId\",\"formatter\":5,\"formatOptions\":{\"showIcon\":true}}],\"filter\":true,\"hierarchySettings\":{\"idColumn\":\"Id\",\"parentColumn\":\"ParentId\",\"treeType\":0,\"expanderColumn\":\"Name\",\"expandTopLevel\":false}},\"mapSettings\":{\"locInfo\":\"CountryRegion\",\"locInfoColumn\":\"Country\",\"latitude\":\"Latitude\",\"longitude\":\"Longitude\",\"sizeSettings\":\"Count\",\"sizeAggregation\":\"Sum\",\"labelSettings\":\"City\",\"legendMetric\":\"Count\",\"numberOfMetrics\":20,\"legendAggregation\":\"Sum\",\"itemColorSettings\":{\"nodeColorField\":\"Count\",\"colorAggregation\":\"Sum\",\"type\":\"heatmap\",\"heatmapPalette\":\"turquoise\"}}}",
                  "isOptional": true
                },
                {
                  "name": "ParameterValues",
                  "value": {
                    "TimeRange": {
                      "type": 4,
                      "value": {
                        "durationMs": 14400000
                      },
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "Last 4 hours",
                      "displayName": "TimeRange",
                      "formattedValue": "Last 4 hours"
                    },
                    "Apps": {
                      "type": 2,
                      "value": [
                        "*"
                      ],
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "All",
                      "displayName": "Apps",
                      "specialValue": [
                        "value::all"
                      ],
                      "formattedValue": "'*'"
                    },
                    "Users": {
                      "type": 2,
                      "value": [
                        "*"
                      ],
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "isGlobal": false,
                      "labelValue": "All",
                      "displayName": "Users",
                      "specialValue": [
                        "value::all"
                      ],
                      "formattedValue": "'*'"
                    },
                    "SigninStatus": {
                      "value": "*",
                      "formattedValue": "*",
                      "labelValue": "*",
                      "type": 1
                    },
                    "LocationDetail": {
                      "value": "{ \"Name\":\"\", \"Type\":\"*\"}",
                      "formattedValue": "{ \"Name\":\"\", \"Type\":\"*\"}",
                      "labelValue": "{ \"Name\":\"\", \"Type\":\"*\"}",
                      "type": 1
                    }
                  },
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                }
              ],
              "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart"
            }
          }
        }
      }
    },
    "metadata": {
      "model": {
        "timeRange": {
          "value": {
            "relative": {
              "duration": 24,
              "timeUnit": 1
            }
          },
          "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
        },
        "filterLocale": {
          "value": "en-us"
        },
        "filters": {
          "value": {
            "MsPortalFx_TimeRange": {
              "model": {
                "format": "local",
                "granularity": "auto",
                "relative": "24h"
              },
              "displayCache": {
                "name": "Local Time",
                "value": "Past 24 hours"
              },
              "filteredPartIds": [
                "StartboardPart-PinnedNotebookQueryPart-aa7f44e3-81b3-463a-9f28-4211b8fa14a1",
                "StartboardPart-PinnedNotebookQueryPart-aa7f44e3-81b3-463a-9f28-4211b8fa14a3",
                "StartboardPart-PinnedNotebookQueryPart-aa7f44e3-81b3-463a-9f28-4211b8fa14a5"
              ]
            }
          }
        }
      }
  },
  "name": "${dashboard_name}",
  "type": "Microsoft.Portal/dashboards",
  "location": "INSERT LOCATION",
  "tags": {
    "hidden-title": "${dashboard_name}"
  },
  "apiVersion": "2015-08-01-preview"
}