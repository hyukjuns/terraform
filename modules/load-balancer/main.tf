resource "azurerm_resource_group" "lb" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "lb" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lb.location
  resource_group_name = azurerm_resource_group.lb.name
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.lb.name
  virtual_network_name = azurerm_virtual_network.lb.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.lb.name
  virtual_network_name = azurerm_virtual_network.lb.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "lb" {
  name                = "${var.prefix}-PublicIPForLB"
  location            = azurerm_resource_group.lb.location
  resource_group_name = azurerm_resource_group.lb.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-LoadBalancer"
  location            = azurerm_resource_group.lb.location
  resource_group_name = azurerm_resource_group.lb.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}
resource "azurerm_lb_backend_address_pool" "lb" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "lb" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb.id]
  probe_id = azurerm_lb_probe.lb.id
}

resource "azurerm_lb_probe" "lb" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "http-running-probe"
  port                = 80
  protocol            = "Http"
  request_path        = "/"
}

resource "azurerm_lb_nat_rule" "lb" {
  resource_group_name            = azurerm_resource_group.lb.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "test"
  protocol                       = "Tcp"
  frontend_port_start            = 10000
  frontend_port_end              = 10101
  backend_port                   = 22
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_network_interface_backend_address_pool_association" "lb" {
  network_interface_id    = azurerm_network_interface.linux_server_nic.id
  ip_configuration_name   = azurerm_network_interface.linux_server_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
  depends_on = [
    azurerm_network_interface.linux_server_nic
  ]
}

