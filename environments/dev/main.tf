terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = " ~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-dev"
    storage_account_name = "hyukjundevsac"
    container_name       = "tfstate"
    key                  = "hyukjun-dev.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "rg-dev-terraform"
  location = "koreacentral"
}

module "network" {
  source                  = "../../modules/00-network"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location

  virtual_network = {
      vnet_name          = "dev-vnet-001"
      vnet_address_space = ["10.0.0.0/16"]
      subnets = [
          {
            name = "dmz-sn"
            address_prefixes = ["10.0.100.0/24"]
          },
          {
            name = "backend-sn"
            address_prefixes = ["10.0.200.0/24"]
          }
        ] 
    }
  nsg = {
    name = "dmz-sn-nsg"
    rules = [
        {
        name                       = "ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_ranges    = [22]
      },
      {
        name                       = "http"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_ranges    = [80, 443]
      }
    ]
  }

  nsg_associate_subnet = true
}