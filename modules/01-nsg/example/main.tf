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

module "nsg" {
  source                  = "../"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location
  attach_nsg_subnet_ids = var.my_subnet_ids
  nsg = {
    name = "test-nsg-terraform"
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