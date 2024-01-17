terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.26.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "function" {
  name     = var.resource_group_name
  location = var.location
}

# Function's SAC and Upload AppFiles (requirements.psd1)
resource "azurerm_storage_account" "function" {
  name                     = "${var.function_app_name}sac"
  resource_group_name      = azurerm_resource_group.function.name
  location                 = azurerm_resource_group.function.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Create Function
resource "azurerm_service_plan" "function" {
  name                = "${var.function_app_name}-svc-plan"
  location            = azurerm_resource_group.function.location
  resource_group_name = azurerm_resource_group.function.name
  os_type             = "Windows"
  sku_name            = "Y1"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_windows_function_app" "function" {
  name                = var.function_app_name
  location            = azurerm_resource_group.function.location
  resource_group_name = azurerm_resource_group.function.name
  service_plan_id     = azurerm_service_plan.function.id

  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key

  site_config {
    application_stack {
      powershell_core_version = "7.2"
    }
  }
  identity {
    type = "SystemAssigned"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Role assign
data "azurerm_subscription" "function" {}
resource "azurerm_role_assignment" "function" {
  scope                = data.azurerm_subscription.function.id
  role_definition_name = "Tag Contributor"
  principal_id         = azurerm_windows_function_app.function.identity[0].principal_id
}

resource "azurerm_function_app_function" "function" {
  name            = "EventGridTrigger-01"
  function_app_id = azurerm_windows_function_app.function.id
  language        = "PowerShell"

  file {
    name    = "run.ps1"
    content = file("./run.ps1")
  }

  config_json = jsonencode({
    "bindings" = [
      {
        "type" : "eventGridTrigger",
        "name" : "eventGridEvent",
        "direction" : "in"
      }
    ]
  })
}

# EventGrid Subscription (System Topic)
resource "azurerm_eventgrid_system_topic" "function" {
  name                   = var.system_topic_name
  location               = "Global"
  resource_group_name    = azurerm_resource_group.function.name
  source_arm_resource_id = data.azurerm_subscription.function.id
  topic_type             = "microsoft.resources.subscriptions"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_eventgrid_system_topic_event_subscription" "function_01" {
  name                = "${var.system_topic_name}-evnet-01"
  system_topic        = azurerm_eventgrid_system_topic.function.name
  resource_group_name = azurerm_resource_group.function.name

  azure_function_endpoint {
    function_id = azurerm_function_app_function.function.id
  }

  included_event_types                 = ["Microsoft.Resources.ResourceWriteSuccess"]
  advanced_filtering_on_arrays_enabled = true
  advanced_filter {
    string_in {
      key = "data.operationName"
      values = [
        "Microsoft.Compute/disks/write",
        "Microsoft.Compute/virtualMachines/write",
        "Microsoft.insights/metricalerts/write",
        "Microsoft.KeyVault/vaults/write",
        "Microsoft.RecoveryServices/vaults/write",
        "Microsoft.Storage/storageAccounts/write",
        "Microsoft.Compute/snapshots/write",
        "Microsoft.Datafactory/Factories/write",
        "Microsoft.Network/NetworkSecurityGroups/write",
        "Microsoft.Network/privateDnsZones/write",
        "Microsoft.Network/privateEndpoints/write",
        "Microsoft.Network/publicIPAddresses/write",
        "Microsoft.Sql/servers/write",
        "Microsoft.Compute/images/write",
        "Microsoft.ContainerRegistry/registries/write",
        "Microsoft.Compute/virtualMachineScaleSets/write",
        "Microsoft.network/loadBalancers/write",
        "Microsoft.Network/networkWatchers/write",
        "Microsoft.operationalInsights/workspaces/write",
        "Microsoft.Network/networkInterfaces/write",
        "Microsoft.portal/dashboards/write",
        "Microsoft.web/serverFarms/write",
        "Microsoft.web/connections/write",
        "Microsoft.automation/automationAccounts/runbooks/write"
      ]
    }
  }
}

resource "azurerm_eventgrid_system_topic_event_subscription" "function_02" {
  name                = "${var.system_topic_name}-evnet-02"
  system_topic        = azurerm_eventgrid_system_topic.function.name
  resource_group_name = azurerm_resource_group.function.name

  azure_function_endpoint {
    function_id = azurerm_function_app_function.function.id
  }

  included_event_types                 = ["Microsoft.Resources.ResourceWriteSuccess"]
  advanced_filtering_on_arrays_enabled = true
  advanced_filter {
    string_in {
      key = "data.operationName"
      values = [
        "Microsoft.web/sites/write",
        "Microsoft.automation/automationAccounts/write",
        "Microsoft.certificateRegistration/certificateOrders/write",
        "Microsoft.cognitiveServices/accounts/write",
        "Microsoft.operationalInsights/queryPacks/write",
        "Microsoft.batch/batchAccounts/write",
        "Microsoft.logic/workflows/write",
        "Microsoft.insights/components/write",
        "Microsoft.operationsManagement/solutions/write",
        "Microsoft.network/virtualNetworks/write",
        "Microsoft.DataProtection/BackupVaults/write",
        "Microsoft.Compute/sshPublicKeys/write",
        "Microsoft.DBforPostgreSQL/servers/write",
        "Microsoft.Network/localnetworkgateways/write",
        "Microsoft.Network/virtualnetworkgateways/write",
        "Microsoft.Network/natgateways/write",
        "Microsoft.Network/applicationgateways/write"
      ]
    }
  }
}