locals {
  public_ip_enabled = [
    for value in var.virtual_machines : value.name
    if value.create_public_ip == true
  ]
}

# compact로 list 값 중 null 제거, list를 set으로 자료형 변환
resource "azurerm_public_ip" "vm" {
  for_each            = toset(local.public_ip_enabled)
  name                = "${each.key}-pip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm" {
  for_each            = { for value in var.virtual_machines : value.name => value }
  name                = "nic-${each.value.name}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  # public ip는 azurerm_public_ip의 이름(가상머신 이름과 동일)과 맞는것만 생성
  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm["${each.value.name}"].id
  }
}

# Filter by OS
locals {
  linux_machines = {
    for value in var.virtual_machines : value.name => value
    if value.os_image == "ubuntu" || value.os_image == "centos"
  }
  windows_machines = {
    for value in var.virtual_machines : value.name => value
    if value.os_image == "windows_server_2022" || value.os_image == "windows_server_2019"
  }
}

/* 
  Create Linux Server
*/
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = { for value in local.linux_machines : value.name => value }
  name                            = each.value.name
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false
  availability_set_id             = each.value.availability_set_id
  zone                            = each.value.av_zone

  network_interface_ids = [
    azurerm_network_interface.vm[each.value.name].id
  ]

  # Linux OS Disk 사이즈의 최소값은 30 GB
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = tonumber(each.value.os_disk_size_gb) < 30 ? "30" : each.value.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.os_image_inventory[each.value.os_image]["publisher"]
    offer     = var.os_image_inventory[each.value.os_image]["offer"]
    sku       = var.os_image_inventory[each.value.os_image]["sku"]
    version   = var.os_image_inventory[each.value.os_image]["version"]
  }
}

/* 
  Create Windows Server
*/
resource "azurerm_windows_virtual_machine" "vm" {
  for_each            = { for value in local.windows_machines : value.name => value }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
  availability_set_id = each.value.availability_set_id
  zone                = each.value.av_zone
  patch_mode          = "AutomaticByPlatform"
  network_interface_ids = [
    azurerm_network_interface.vm[each.value.name].id
  ]

  # Windows OS Disk 사이즈의 최소값은 127 GB
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = tonumber(each.value.os_disk_size_gb) < 127 ? "127" : each.value.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.os_image_inventory[each.value.os_image]["publisher"]
    offer     = var.os_image_inventory[each.value.os_image]["offer"]
    sku       = var.os_image_inventory[each.value.os_image]["sku"]
    version   = var.os_image_inventory[each.value.os_image]["version"]
  }
}