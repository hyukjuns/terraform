resource "azurerm_network_interface" "dev_web_nic_00" {
  name                = "${var.prefix}-web-nic-00"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dev_web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Avset
resource "azurerm_availability_set" "dev_web_avset" {
  name                = "dev-web-avset"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name

  platform_fault_domain_count = 2

  tags = {
    environment = "Development"
  }
}

# count indexing -> <TYPE><NAME>[<INDEX>]
resource "azurerm_linux_virtual_machine" "dev_web_server_00" {
  name                = "${var.prefix}-web-server-00"
  resource_group_name = azurerm_resource_group.web_rg.name
  location            = azurerm_resource_group.web_rg.location
  size                = "Standard_DS1_v2"

  disable_password_authentication = false
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  availability_set_id             = azurerm_availability_set.dev_web_avset.id

  network_interface_ids = [
    azurerm_network_interface.dev_web_nic_00.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "dev_web_nic_01" {
  name                = "${var.prefix}-web-nic-01"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dev_web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "dev_web_server_01" {
  name                = "${var.prefix}-web-server-01"
  resource_group_name = azurerm_resource_group.web_rg.name
  location            = azurerm_resource_group.web_rg.location
  size                = "Standard_DS1_v2"

  disable_password_authentication = false
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  availability_set_id             = azurerm_availability_set.dev_web_avset.id

  network_interface_ids = [
    azurerm_network_interface.dev_web_nic_01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
