variable "resource_group_name" {
  type        = string
  description = "resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "resource group location"
}

variable "virtual_network" {
  type = object(
    {
      vnet_name          = string
      vnet_address_space = list(string)
      subnets = list(object(
        {
          name             = string
          address_prefixes = list(string)
        }
      ))
    }
  )
  description = "manage virtual network and subnet"
}