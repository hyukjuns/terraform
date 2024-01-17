variable "linux_image" {
  description = "ubuntu or centos"
  type        = map(any)
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
variable "windows_image" {
  description = "windows server"
  type        = map(any)
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
variable "admin_username" {
  type        = string
  description = "VM User"
  sensitive   = true
}
variable "admin_password" {
  type        = string
  description = "VM User"
  sensitive   = true
}
variable "prefix" {
  type        = string
  description = "Resource Naming Convention"
}
variable "nsg_source_ip_address" {
  type        = string
  description = "Source IP Address, Connect to VM via ssh or rdp"
}
