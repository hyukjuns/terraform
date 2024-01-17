provider "azurerm" {
  features {
    
  }
}

module "disk" {
  source = "../"
  resource_group_name = "test"
  resource_group_location = "koreacentral"
  data_disks = [{
    name = "datadisk-01"
    storage_account_type = "StandardSSD_ZRS"
    disk_size_gb = "40"
    vm_id = module.vm.vm_id
    lun = "3"
  }]
}