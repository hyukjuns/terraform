variable "cnt" {
    description = "vm count"
    default = "1"
}
variable "image" {
    description = "ubuntu or centos"
    type = map
    default = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
    }
}
variable "admin_username" {
    sensitive = true
}
variable "admin_password" {
    sensitive = true
}
variable "prefix" {
    default = "hyukjun"
}
