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

variable "nsg" {
  type = object({
    name                   = string
    attach_to_subnet_names = optional(list(string))
    attach_to_nic_ids      = optional(list(string))
    rules = list(object(
      {
        name                       = string
        priority                   = string
        direction                  = string
        access                     = string
        protocol                   = string
        source_address_prefix      = string
        source_port_range          = string
        destination_address_prefix = string
        destination_port_ranges    = list(string)
      }
    ))
  })
  description = "nsg name, rules"
}

variable "nsg_associate_subnet" {
  type        = bool
  description = "associate nsg to subnet, default = true"
  default     = true
}

variable "nsg_association_nic" {
  type        = bool
  description = "associatte nsg to nic, default = false"
  default     = false
}

variable "nic_ids" {
  type        = list(string)
  description = "nic id list, use for nsg associate, default = black list"
  default     = []
}