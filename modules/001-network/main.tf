resource "azurerm_virtual_network" "network" {
  name                = var.virtual_network["vnet_name"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.virtual_network["vnet_address_space"]
}

resource "azurerm_subnet" "network" {
  for_each             = { for value in var.virtual_network["subnets"] : value.name => value }
  name                 = each.value.name
  address_prefixes     = each.value.address_prefixes
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.network.name

  depends_on = [
    azurerm_virtual_network.network
  ]
}