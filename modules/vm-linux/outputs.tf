output "linux_public_ip" {
    value = azurerm_linux_virtual_machine.linux_server[0].public_ip_address
}