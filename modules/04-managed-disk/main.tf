resource "random_id" "vm" {
  for_each = { for index, value in var.data_disks : index => value }
  keepers = {
    id = each.value.name
  }
  byte_length = 4
}

resource "azurerm_managed_disk" "vm" {
  for_each             = { for index, value in var.data_disks : index => value }
  name                 = "data-disk-${each.value.name}${random_id.vm[each.key].hex}"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type != null ? each.value.storage_account_type : "Standard_LRS"
  create_option        = each.value.create_option != null ? each.value.create_option : "Empty"
  disk_size_gb         = each.value.disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm" {
  for_each           = { for index, value in var.data_disks : index => value }
  managed_disk_id    = azurerm_managed_disk.vm[each.key].id
  virtual_machine_id = each.value.vm_id
  lun                = each.value.lun
  caching            = each.value.caching != null ? each.value.caching : "ReadWrite"
}