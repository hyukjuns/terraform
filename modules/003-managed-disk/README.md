<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (3.87.0)

- <a name="provider_random"></a> [random](#provider\_random) (3.6.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_managed_disk.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) (resource)
- [azurerm_virtual_machine_data_disk_attachment.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) (resource)
- [random_id.vm](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks)

Description: Data Disk Info

Type:

```hcl
list(object(
    {
      name                 = string
      storage_account_type = optional(string)
      create_option        = optional(string)
      disk_size_gb         = string
      vm_id                = string
      lun                  = string
      caching              = optional(string)
    }
  ))
```

### <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location)

Description: Resource Group Location

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Resource Group Name

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->