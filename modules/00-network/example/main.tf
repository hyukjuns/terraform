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
  nsg = {
    name                   = "dmz-sn-nsg"
    attach_to_subnet_names = ["dmz-sn"]
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
}

output "subnet_id" {
  value = module.network.subnet_ids
}