variable "resource_group_name" {
  type        = string
  description = "resource group name"
}
variable "resource_group_location" {
  type        = string
  description = "resource group location"
}

variable "virtual_machines" {
  type = list(object(
    {
      name                = string
      size                = string
      admin_username      = string
      admin_password      = string
      os_image            = string
      os_disk_size_gb     = string
      subnet_id           = string
      create_public_ip    = bool
      availability_set_id = optional(string)
      av_zone             = optional(string)
    }
  ))
  description = "virtual machine's info"
}

variable "os_image_inventory" {
  type        = map(any)
  description = "Available vm image in krc"
  default = {
    ubuntu = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    },
    centos = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "8_5-gen2"
      version   = "latest"
    }
    windows_server_2022 = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition-core"
      version   = "latest"
    },
    windows_server_2019 = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter"
      version   = "latest"
    }
  }
}

    