terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = " ~> 3.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "rg-test"
  location = "koreacentral"
  tags = {
    env    = "prod"
    target = "me"
  }
  lifecycle {
    postcondition {
      condition     = self.tags["env"] == "dev"
      error_message = "env tag is not valid"
    }
  }

}
resource "azurerm_network_security_group" "test" {
  for_each            = var.test
  name                = each.value
  resource_group_name = azurerm_resource_group.test.name
  location            = "koreacentral"
}

variable "test" {
  type    = set(string)
  default = ["test4", "test5", "test6"]
}