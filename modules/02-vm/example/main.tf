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

variable "admin_password" {
  type = string
}

data "azurerm_resource_group" "vm" {
  name = "rg-dev-terraform"
}

resource "azurerm_availability_set" "vm" {
  name                        = "dev-avset-terraform"
  location                    = data.azurerm_resource_group.vm.location
  resource_group_name         = data.azurerm_resource_group.vm.name
  platform_fault_domain_count = 2
}

module "vm" {
  source                  = "../"
  resource_group_name     = data.azurerm_resource_group.vm.name
  resource_group_location = data.azurerm_resource_group.vm.location
  virtual_machines = [
    {
      name                = "testvm"
      size                = "Standard_F2"
      admin_username      = "azureuser"
      admin_password      = var.admin_password
      os_image            = "ubuntu"
      os_disk_size_gb     = "30"
      subnet_id           = ""
      availability_set_id = azurerm_availability_set.vm.id
      create_public_ip    = true
    },
    {
      name                = "testvm-windows"
      size                = "Standard_F2"
      admin_username      = "azureuser"
      admin_password      = var.admin_password
      os_image            = "windows_server_2019"
      os_disk_size_gb     = "127"
      subnet_id           = ""
      availability_set_id = azurerm_availability_set.vm.id
      create_public_ip    = true
    }
  ]
  depends_on = [azurerm_availability_set.vm]
}