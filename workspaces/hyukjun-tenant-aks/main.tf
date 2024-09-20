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

# Network
module "network" {
  source                  = "../../modules/001-network"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location

  virtual_network = {
      vnet_name          = "dev-vnet-001"
      vnet_address_space = ["10.0.0.0/16"]
      subnets = [
          {
            name = "sn-01"
            address_prefixes = ["10.0.100.0/24"]
          },
          {
            name = "sn-02"
            address_prefixes = ["10.0.200.0/24"]
          }
        ] 
    }
}
module "nsg_01" {
  source = "../../modules/002-nsg"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location
  attach_nsg_subnet_ids = [
    module.network.subnet_ids["sn-01"] 
  ]
  nsg = {
    name = "sn-01-nsg"
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
module "nsg_02" {
  source = "../../modules/002-nsg"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location
  attach_nsg_subnet_ids = [ 
    module.network.subnet_ids["sn-02"]
  ]
  nsg = {
    name = "sn-02-nsg"
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

# VM
resource "azurerm_availability_set" "test" {
  name                        = "dev-avset-terraform"
  location                    = azurerm_resource_group.test.location
  resource_group_name         = azurerm_resource_group.test.name
  platform_fault_domain_count = 2
}

module "vm" {
  source                  = "../../modules/004-virtualmachine"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location
  virtual_machines = [
    {
      name                = "tftest-linux-vm-001"
      size                = "Standard_F2"
      admin_username      = var.my_admin_username
      admin_password      = var.my_admin_password
      os_image            = "ubuntu"
      os_disk_size_gb     = "30"
      subnet_id           = module.network.subnet_ids["sn-01"]
      availability_set_id = azurerm_availability_set.test.id
      create_public_ip    = true
    },
    {
      name                = "tftest-window-vm-001"
      size                = "Standard_F2"
      admin_username      = var.my_admin_username
      admin_password      = var.my_admin_password
      os_image            = "windows_server_2019"
      os_disk_size_gb     = "127"
      subnet_id           = module.network.subnet_ids["sn-02"]
      create_public_ip    = true
    }
  ]
  depends_on = [azurerm_availability_set.test]
}