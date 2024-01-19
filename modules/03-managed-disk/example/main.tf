provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = "rg-dev-terraform"
  location = "koreacentral"
}

module "network" {
  source                  = "../../00-network"
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

resource "azurerm_availability_set" "vm" {
  name                        = "dev-avset-terraform"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  platform_fault_domain_count = 2
}

variable "admin_username" {
  default = "azureuser"
}
variable "admin_password" {
  default = "passworddkagh1."
}
module "vm" {
  source                  = "../../01-vm"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location
  virtual_machines = [
    {
      name                = "testvm"
      size                = "Standard_F2"
      admin_username      = "azureuser"
      admin_password      = var.admin_password
      os_image            = "ubuntu"
      os_disk_size_gb     = "30"
      subnet_id           = module.network.subnet_ids["dmz-sn"]
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
      subnet_id           = module.network.subnet_ids["backend-sn"]
      availability_set_id = azurerm_availability_set.vm.id
      create_public_ip    = true
    }
  ]
  depends_on = [azurerm_availability_set.vm]
}

module "disk" {
  source = "../"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location
  data_disks = [{
    name = "datadisk-01"
    storage_account_type = "StandardSSD_ZRS"
    disk_size_gb = "10"
    vm_id = module.vm.id_list[0]
    lun = "1"
  }]
}