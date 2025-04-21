provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-terraform-test"
  location = "koreacentral"
}

module "network" {
  source                  = "../../001-network"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location

  virtual_network = {
    vnet_name          = "tf-aks-vnet-001"
    vnet_address_space = ["192.168.0.0/16"]
    subnets = [
      {
        name             = "sn-aks-node-01"
        address_prefixes = ["192.168.200.0/24"]
      },
      {
        name             = "sn-aks-node-02"
        address_prefixes = ["192.168.100.0/24"]
      }
    ]
  }
}

module "aks-01" {
  source                  = "../"
  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location
  cluster_name            = "tf-test-aks-cluster-001"
  subnet_id               = module.network.subnet_ids["sn-aks-node-01"]
  k8s_version             = "1.30.9"
  identity_role_scope     = azurerm_resource_group.example.id
}

# module "aks-02" {
#   source                  = "../"
#   resource_group_name     = azurerm_resource_group.example.name
#   resource_group_location = azurerm_resource_group.example.location
#   cluster_name            = "tf-test-aks-cluster-002"
#   subnet_id               = module.network.subnet_ids["sn-aks-node-02"]
#   k8s_version             = "1.30.9"
#   identity_role_scope     = azurerm_resource_group.example.id
# }