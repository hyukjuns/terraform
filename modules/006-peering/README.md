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

- [azurerm_virtual_network_peering.network_1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) (resource)
- [azurerm_virtual_network_peering.network_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_remote_vnet_id"></a> [remote\_vnet\_id](#input\_remote\_vnet\_id)

Description: Peering VNET ID 2

Type: `string`

### <a name="input_remote_vnet_name"></a> [remote\_vnet\_name](#input\_remote\_vnet\_name)

Description: Peering VNET 이름 2

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: 리소스 그룹 이름

Type: `string`

### <a name="input_source_vnet_id"></a> [source\_vnet\_id](#input\_source\_vnet\_id)

Description: Peering VNET ID 1

Type: `string`

### <a name="input_source_vnet_name"></a> [source\_vnet\_name](#input\_source\_vnet\_name)

Description: Peering VNET 이름 1

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->