variable "resource_group_name" {
  type        = string
  description = "resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "resource group location"
}

variable "nsg" {
  type = list(object(
      {
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
      }
    )
  )
  description = "nsg name, rules"
}

variable "nic_ids" {
  type        = list(string)
  description = "nic id list, use for nsg associate, default = black list"
  default     = []
}