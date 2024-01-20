output "id_list" {
  value = [
    for value in azurerm_linux_virtual_machine.vm : value.id
  ]
}

output "identity_list" {
  value = [
    for value in azurerm_linux_virtual_machine.vm : value.identity
  ]
}

output "private_ip_address_list" {
  value = [
    for value in azurerm_linux_virtual_machine.vm : value.private_ip_address
  ]
}
output "public_ip_address_list" {
  value = [
    for value in azurerm_linux_virtual_machine.vm : value.public_ip_address
  ]
}

output "virtual_machine_id_list" {
  value = [
    for value in azurerm_linux_virtual_machine.vm : value.virtual_machine_id
  ]
}