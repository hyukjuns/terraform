terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
        resource_group_name  = "rg-backend"
        storage_account_name = "tfbetestsac001"
        container_name       = "backend"
        key                  = "dev-002.cluster.tfstate"
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks" {
  name     = "rg-${var.resource_group_name}"
  location = var.location
}

resource "azurerm_virtual_network" "aks" {
  name                = "${var.prefix}-aks-vnet-002"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = ["10.100.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                 = "azurecni-subnet"
  virtual_network_name = azurerm_virtual_network.aks.name
  resource_group_name  = azurerm_resource_group.aks.name
  address_prefixes     = ["10.100.0.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks-cluster-002"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  # k8s version
  kubernetes_version        = var.k8s_version
  automatic_channel_upgrade = "stable"

  # Basic
  dns_prefix = "${var.prefix}aks"

  default_node_pool {
    name                = "default"
    type                = "VirtualMachineScaleSets"
    zones               = [1, 2, 3]
    node_count          = 3
    vm_size             = "Standard_D2as_v4"
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
  }

  # Network
  network_profile {
    network_plugin     = "azure"
    network_mode       = "transparent"
    network_policy     = "calico"
    service_cidr       = "10.0.0.0/16"
    dns_service_ip     = "10.0.0.10"
    outbound_type      = "loadBalancer"
    load_balancer_sku  = "standard"
  }

  # Identity
  identity {
    type = "SystemAssigned"
  }

  azure_policy_enabled = true
}