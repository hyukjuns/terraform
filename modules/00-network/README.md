<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) ( ~> 3.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (3.86.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_subnet.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location)

Description: resource group location

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: resource group name

Type: `string`

### <a name="input_virtual_network"></a> [virtual\_network](#input\_virtual\_network)

Description: manage virtual network and subnet

Type:

```hcl
object(
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
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids)

Description: subnet id in map

### <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names)

Description: subnet name in list

### <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space)

Description: virtual network address\_space

### <a name="output_vnet_guid"></a> [vnet\_guid](#output\_vnet\_guid)

Description: virtual network guid

### <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id)

Description: virtual network id

### <a name="output_vnet_location"></a> [vnet\_location](#output\_vnet\_location)

Description: virtual network location

### <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name)

Description: virtual network name

### <a name="output_vnet_resource_group_name"></a> [vnet\_resource\_group\_name](#output\_vnet\_resource\_group\_name)

Description: virtual network resource group name
<!-- END_TF_DOCS -->