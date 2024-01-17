output "vm_public_ip_address" {
  value = [
    for value in azurerm_linux_virtual_machine.vm : value.public_ip_address
  ]
}