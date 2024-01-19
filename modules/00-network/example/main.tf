terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = " ~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-dev-terraform"
  location = "koreacentral"
}

module "network" {
  source                  = "../"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location

  virtual_network = {
    vnet_name          = "dev-vnet-001"
    vnet_address_space = ["10.0.0.0/16"]
    subnets = [
      {
        name             = "dmz-sn"
        address_prefixes = ["10.0.100.0/24"]
      },
      {
        name             = "backend-sn"
        address_prefixes = ["10.0.200.0/24"]
      }
    ]
  }
}