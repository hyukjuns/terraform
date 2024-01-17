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

resource "azurerm_network_security_group" "network" {
  name                = var.nsg["name"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "network" {
  for_each                    = { for index, value in var.nsg["rules"] : index => value }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_ranges     = each.value.destination_port_ranges
  network_security_group_name = azurerm_network_security_group.network.name
  resource_group_name         = var.resource_group_name

  depends_on = [
    azurerm_network_security_group.network
  ]
}

resource "azurerm_subnet_network_security_group_association" "network" {
  for_each                  = toset((compact(var.nsg["attach_to_subnet_names"])))
  subnet_id                 = azurerm_subnet.network[each.value].id
  network_security_group_id = azurerm_network_security_group.network.id
}

resource "azurerm_network_interface_security_group_association" "network" {
  count                     = var.nsg["attach_to_subnet_names"] == null && var.nsg["attach_to_nic_ids"] != null ? length(var.nsg["attach_to_nic_ids"]) : 0
  network_interface_id      = var.nsg["attach_to_nic_ids"][count.index]
  network_security_group_id = azurerm_network_security_group.network.id
}