terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = " ~> 4.0"
    }
  }
  backend "azurerm" {
    # use_azuread_auth     = true
    # use_cli              = true
    # tenant_id            = "ba36f73c-a9a4-4f74-a418-1cb412219c61"
    resource_group_name = "rg-terraform"
    storage_account_name = "hyukjuntfstatebackend"
    container_name       = "tfbackend-01"
    key                  = "devappgw.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "appgw" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_public_ip" "appgw" {
  name                = "${var.prefix}-appgw-pip"
  location            = azurerm_resource_group.appgw.location
  resource_group_name = azurerm_resource_group.appgw.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "network" {
  source                  = "../001-network"
  resource_group_name     = azurerm_resource_group.appgw.name
  resource_group_location = azurerm_resource_group.appgw.location

  virtual_network = {
    vnet_name          = "dev-vnet-001"
    vnet_address_space = ["10.0.0.0/16"]
    subnets = [
      {
        name             = "dev-sn-01"
        address_prefixes = ["10.0.100.0/24"]
      },
      {
        name             = "dev-sn-02"
        address_prefixes = ["10.0.200.0/24"]
      }
    ]
  }
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "bepool"
  frontend_port_name             = "feport"
  frontend_ip_configuration_name = "feip"
  http_setting_name              = "besetting"
  listener_name                  = "http-listener"
  request_routing_rule_name      = "rt-rule"
  # listener_host_names            = ["*"]
}

resource "azurerm_application_gateway" "appgw" {
  name                = "${var.prefix}-appgw"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location

  # SKU
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  # Frontend
  gateway_ip_configuration {
    name      = "${var.prefix}-appgw-ip-configuration"
    subnet_id = module.network.subnet_ids["dev-sn-01"]
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  # Backend pool
  backend_address_pool {
    name = local.backend_address_pool_name
  }

  # BAckend HTTP Setting
  backend_http_settings {
    name                  = local.http_setting_name
    protocol              = "Http"
    port                  = 80
    cookie_based_affinity = "Enabled"
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    request_timeout       = 120
    connection_draining {
      enabled           = true
      drain_timeout_sec = 60
    }
  }

  # Listener
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
    # host_names                     = local.listener_host_names
  }

  # Routing Rule
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 100
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "appgw" {
  network_interface_id    = azurerm_network_interface.backend.id
  ip_configuration_name   = "${var.prefix}-linux-server-ip-config"
  backend_address_pool_id = tolist(azurerm_application_gateway.appgw.backend_address_pool).0.id
}