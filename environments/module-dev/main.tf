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
}
module "nsg_dmz" {
  source = "../../modules/01-nsg"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location
  attach_nsg_subnet_ids = [
    module.network.subnet_ids["dmz-sn"] 
  ]
  nsg = {
    name = "dmz-sn-nsg"
    rules = [
        {
        name                       = "http"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_ranges    = [80,8080]
      },
      {
        name                       = "https"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_ranges    = [443]
      }
    ]
  }
}
module "nsg_backend" {
  source = "../../modules/01-nsg"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location
  attach_nsg_subnet_ids = [ 
    module.network.subnet_ids["backend-sn"]
  ]
  nsg = {
    name = "backend-sn-nsg"
    rules = [
        {
        name                       = "ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "10.0.200.0/24"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_ranges    = [22]
      },
      {
        name                       = "mysql"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "10.0.100.0/24"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_ranges    = [3306]
      }
    ]
  }
}

resource "azurerm_availability_set" "test" {
  name                        = "dev-avset-terraform"
  location                    = azurerm_resource_group.test.location
  resource_group_name         = azurerm_resource_group.test.name
  platform_fault_domain_count = 2
}

module "vm" {
  source                  = "../../modules/02-vm"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location
  virtual_machines = [
    {
      name                = "testvm-linux"
      size                = "Standard_F2"
      admin_username      = var.my_admin_username
      admin_password      = var.my_admin_password
      os_image            = "ubuntu"
      os_disk_size_gb     = "30"
      subnet_id           = module.network.subnet_ids["dmz-sn"]
      availability_set_id = azurerm_availability_set.test.id
      create_public_ip    = true
    },
    {
      name                = "testvm-windows"
      size                = "Standard_F2"
      admin_username      = var.my_admin_username
      admin_password      = var.my_admin_password
      os_image            = "windows_server_2019"
      os_disk_size_gb     = "127"
      subnet_id           = module.network.subnet_ids["backend-sn"]
      create_public_ip    = true
    }
  ]
  depends_on = [azurerm_availability_set.test]
}