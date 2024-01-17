variable "test" {
  type = list(object(
    {
      name                = string
      pip = bool
    }
  ))
  default = [ {
    name = "test1"
    pip = true   
  },
  {
    name = "test2"
    pip = false
  }
   ]
}
locals {
  public_ip_enabled = [
    for value in var.test :
     value.pip ? value.name : null
  ]
}

output "test" {
  value = compact(local.public_ip_enabled)
}
provider "azurerm" {
  features {
    
  }
}
resource "azurerm_public_ip" "vm" {
  for_each = toset(compact(local.public_ip_enabled))
  name                = "${each.key}-pip-${each.value}"
  resource_group_name = "test"
  location            = "koreacentral"
  allocation_method   = "Static"
}
