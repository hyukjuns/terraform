provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-dev-terraform"
  location = "koreacentral"
}
resource "azurerm_availability_set" "vm" {
  name                        = "dev-avset-terraform"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  platform_fault_domain_count = 2
}
module "disk" {
  source                  = "../"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location
  data_disks = [{
    name                 = "datadisk-01"
    storage_account_type = "StandardSSD_ZRS"
    disk_size_gb         = "10"
    vm_id                = module.vm.id_list[0]
    lun                  = "1"
  }]
}