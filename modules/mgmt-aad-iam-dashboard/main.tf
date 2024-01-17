terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "hyukjunterraformbackend"
    container_name       = "test-mgmt-backend"
    key                  = "test-mgmt.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "dashboard" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "dashboard" {
  name                = "${var.prefix}-la-01"
  location            = azurerm_resource_group.dashboard.location
  resource_group_name = azurerm_resource_group.dashboard.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_aad_diagnostic_setting" "dashboard" {
  name                       = "test-mgmt"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.dashboard.id
  log {
    category = "SignInLogs"
    enabled  = true
    retention_policy {}
  }
  log {
    category = "AuditLogs"
    enabled  = true
    retention_policy {}
  }
  log {
    category = "NonInteractiveUserSignInLogs"
    enabled  = true
    retention_policy {}
  }
  log {
    category = "ServicePrincipalSignInLogs"
    enabled  = true
    retention_policy {}
  }
  log {
    category = "ManagedIdentitySignInLogs"
    enabled  = false
    retention_policy {}
  }
  log {
    category = "ProvisioningLogs"
    enabled  = false
    retention_policy {}
  }
  log {
    category = "ADFSSignInLogs"
    enabled  = false
    retention_policy {}
  }
}

resource "azurerm_portal_dashboard" "dashboard" {
  name                = "${var.prefix}-dashboard"
  resource_group_name = azurerm_resource_group.dashboard.name
  location            = azurerm_resource_group.dashboard.location
  dashboard_properties = templatefile("dashboard.tpl",
    {
      subscription_id = data.azurerm_subscription.current.subscription_id
      rg_name         = azurerm_resource_group.dashboard.name
      la_name         = azurerm_log_analytics_workspace.dashboard.name
      dashboard_name  = "${var.prefix}-dashboard"
  })
  depends_on = [
    azurerm_monitor_aad_diagnostic_setting.dashboard
  ]
}