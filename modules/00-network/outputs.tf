output "vnet_id" {
  value       = azurerm_virtual_network.network.id
  description = "virtual network id"
}
output "vnet_guid" {
  value       = azurerm_virtual_network.network.guid
  description = "virtual network guid"
}
output "vnet_name" {
  value       = azurerm_virtual_network.network.name
  description = "virtual network name"
}
output "vnet_address_space" {
  value       = azurerm_virtual_network.network.address_space
  description = "virtual network address_space"
}

output "vnet_resource_group_name" {
  value       = azurerm_virtual_network.network.resource_group_name
  description = "virtual network resource group name"
}

output "vnet_location" {
  value       = azurerm_virtual_network.network.location
  description = "virtual network location"
}

# map
output "subnet_ids" {
  value = {
    for value in azurerm_subnet.network : value.name => value.id
  }
  description = "subnet id in map"
}

# list
output "subnet_names" {
  value = [
    for value in azurerm_subnet.network : value.name
  ]
  description = "subnet name in list"
}
output "nsg_id" {
  value       = azurerm_network_security_group.network.id
  description = "nsg id"
}