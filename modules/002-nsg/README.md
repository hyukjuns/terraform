<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) ( ~> 3.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) ( ~> 3.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_network_interface_security_group_association.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) (resource)
- [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_rule.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_subnet_network_security_group_association.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_nsg"></a> [nsg](#input\_nsg)

Description: nsg name, rules

Type:

```hcl
object(
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
```

### <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location)

Description: resource group location

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: resource group name

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_attach_nsg_nic_ids"></a> [attach\_nsg\_nic\_ids](#input\_attach\_nsg\_nic\_ids)

Description: n/a

Type: `list(string)`

Default: `[]`

### <a name="input_attach_nsg_subnet_ids"></a> [attach\_nsg\_subnet\_ids](#input\_attach\_nsg\_subnet\_ids)

Description: n/a

Type: `list(string)`

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id)

Description: nsg id
<!-- END_TF_DOCS -->