output "linux_server_pip" {
  value = azurerm_linux_virtual_machine.linux_server.public_ip_address
}
output "windows_server_pip" {
  value = azurerm_windows_virtual_machine.windows_server.public_ip_address
}