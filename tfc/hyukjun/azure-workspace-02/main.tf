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
      name = "azure-workspace-02"
    }
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "network" {
  backend = "remote"
  config = {
    organization = "hyukjun"
    workspaces = {
      name = "azure-workspace-01"
    }
  }
}

resource "azurerm_network_interface" "tfc" {
  name                = "tfc-nic"
  location            = data.terraform_remote_state.network.outputs.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.terraform_remote_state.network.outputs.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "tfc" {
  name                = "tfc-machine"
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = data.terraform_remote_state.network.outputs.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "dkagh1.dkagh1."
  network_interface_ids = [
    azurerm_network_interface.tfc.id,
  ]
  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
