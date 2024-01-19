resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for value in var.nsg : value.name => value
  }
  name                = each.value.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "nsg" {
  for_each                    = {
     for value in var.nsg : value.name => value.rules
  }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_ranges     = each.value.destination_port_ranges
  network_security_group_name = azurerm_network_security_group.nsg[each.key].name
  resource_group_name         = var.resource_group_name

  depends_on = [
    azurerm_network_security_group.nsg[each.key]
  ]
}

locals {
  subnet_names = {
    for value in var.nsg : value.name => value.attach_to_subnet_names
  }
  nic_ids = {
    for value in var.nsg : value.name => value.attach_to_nic_ids
  }
}

resource "azurerm_subnet_network_security_group_association" "network" {
  for_each = local.subnet_names
  #for_each                  = toset((compact(var.nsg["attach_to_subnet_names"])))
  subnet_id                 = azurerm_subnet.network[each.value].id
  network_security_group_id = azurerm_network_security_group.network.id
}

resource "azurerm_network_interface_security_group_association" "network" {
  count                     = var.nsg["attach_to_subnet_names"] == null && var.nsg["attach_to_nic_ids"] != null ? length(var.nsg["attach_to_nic_ids"]) : 0
  network_interface_id      = var.nsg["attach_to_nic_ids"][count.index]
  network_security_group_id = azurerm_network_security_group.network.id
}