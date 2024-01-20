variable "resource_group_name" {
  type        = string
  description = "resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "resource group location"
}

variable "nsg" {
  type = object(
    {
      name = string
      rules = set(object(
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
        )
      )
    }
  )
  description = "nsg name, rules"
}

variable "attach_nsg_subnet_ids" {
  type = list(string)
  default = []
}
variable "attach_nsg_nic_ids" {
  type = list(string)
  default = []
}