terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "hyukjunterraformbackend"
    container_name       = "test-mgmt-backend"
    key                  = "test-mgmt-rbac.tfstate"
  }
}

provider "azuread" {
  # Configuration options
}

provider "azurerm" {
  # Configuration options
  features {}
}

data "azurerm_subscription" "rbac" {}
data "azuread_client_config" "rbac" {}


# Create User
resource "azuread_user" "rbac" {
  user_principal_name = "testuser@${var.email_address}"
  display_name        = "testuser"
  password            = var.user_password
}

# # Invite User
resource "azuread_invitation" "rbac" {
  user_email_address = var.external_user
  redirect_url       = "https://portal.azure.com"

  message {
    language = "en-US"
  }
}

# Assign Role to Application and User
resource "azurerm_role_assignment" "rbac_user_01" {
  scope                = data.azurerm_subscription.rbac.id
  role_definition_name = var.azure_roles["Reader"]
  principal_id         = azuread_user.rbac.object_id
}
resource "azurerm_role_assignment" "rbac_user_02" {
  scope                = data.azurerm_subscription.rbac.id
  role_definition_name = var.azure_roles["Reader"]
  principal_id         = azuread_invitation.rbac.user_id
}