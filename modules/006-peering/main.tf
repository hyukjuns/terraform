resource "azurerm_virtual_network_peering" "network_1" {
  name                      = "peer1to2"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.source_vnet_name
  remote_virtual_network_id = var.remote_vnet_id
}

resource "azurerm_virtual_network_peering" "network_2" {
  name                      = "peer2to1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.remote_vnet_name
  remote_virtual_network_id = var.source_vnet_id
}