terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  cloud {
    organization = "hyukjun"
    workspaces {
      name = "azure-workspace-vcs"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfc" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "tfc" {
  name                = "tfc-network"
  location            = azurerm_resource_group.tfc.location
  resource_group_name = azurerm_resource_group.tfc.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
}