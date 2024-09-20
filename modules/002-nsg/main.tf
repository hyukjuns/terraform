resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg["name"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "nsg" {
  for_each = {
    for value in var.nsg["rules"] : value.name => value
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
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  count                  = length(var.attach_nsg_subnet_ids)
  subnet_id                 = var.attach_nsg_subnet_ids[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "nsg" {
  count                  = length(var.attach_nsg_nic_ids)
  network_interface_id      = var.attach_nsg_nic_ids[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.id
}