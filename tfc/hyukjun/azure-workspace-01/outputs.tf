output "resource_group_name" {
  value = azurerm_resource_group.tfc.name
}
output "location" {
  value = azurerm_resource_group.tfc.location
}
output "subnet_id" {
  value = azurerm_virtual_network.tfc.subnet.*.id[0]
}