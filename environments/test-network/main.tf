provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-dev-terraform"
  location = "koreacentral"
}

module "network" {
  source                  = "../../modules/00-network"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location

  virtual_network = {
    vnet_name          = "dev-vnet-001"
    vnet_address_space = ["10.0.0.0/16"]
    subnets = [
      {
        name             = "dmz-sn"
        address_prefixes = ["10.0.100.0/24"]
      },
      {
        name             = "backend-sn"
        address_prefixes = ["10.0.200.0/24"]
      }
    ]
  }
}
module "network2" {
  source                  = "../../modules/00-network"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location

  virtual_network = {
    vnet_name          = "dev-vnet-002"
    vnet_address_space = ["172.16.0.0/16"]
    subnets = [
      {
        name             = "dmz-sn"
        address_prefixes = ["172.16.1.0/24"]
      },
      {
        name             = "backend-sn"
        address_prefixes = ["172.16.2.0/24"]
      }
    ]
  }
}

module "peering" {
  source              = "../../modules/06-peering"
  resource_group_name = azurerm_resource_group.example.name
  source_vnet_name    = module.network.vnet_name
  source_vnet_id      = module.network.vnet_id
  remote_vnet_name    = module.network2.vnet_name
  remote_vnet_id      = module.network2.vnet_id
}