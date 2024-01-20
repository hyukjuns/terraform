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

- [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) (resource)
- [azurerm_network_interface.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) (resource)
- [azurerm_public_ip.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location)

Description: resource group location

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: resource group name

Type: `string`

### <a name="input_virtual_machines"></a> [virtual\_machines](#input\_virtual\_machines)

Description: virtual machine's info

Type:

```hcl
list(object(
    {
      name                = string
      size                = string
      admin_username      = string
      admin_password      = string
      os_image            = string
      os_disk_size_gb     = string
      subnet_id           = string
      create_public_ip    = bool
      availability_set_id = optional(string)
      av_zone             = optional(string)
    }
  ))
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_os_image_inventory"></a> [os\_image\_inventory](#input\_os\_image\_inventory)

Description: Available vm image in krc

Type: `map(any)`

Default:

```json
{
  "centos": {
    "offer": "CentOS",
    "publisher": "OpenLogic",
    "sku": "8_5-gen2",
    "version": "latest"
  },
  "ubuntu": {
    "offer": "0001-com-ubuntu-server-jammy",
    "publisher": "Canonical",
    "sku": "22_04-lts",
    "version": "latest"
  },
  "windows_server_2019": {
    "offer": "WindowsServer",
    "publisher": "MicrosoftWindowsServer",
    "sku": "2019-datacenter",
    "version": "latest"
  },
  "windows_server_2022": {
    "offer": "WindowsServer",
    "publisher": "MicrosoftWindowsServer",
    "sku": "2022-datacenter-azure-edition-core",
    "version": "latest"
  }
}
```

## Outputs

The following outputs are exported:

### <a name="output_id_list"></a> [id\_list](#output\_id\_list)

Description: n/a

### <a name="output_identity_list"></a> [identity\_list](#output\_identity\_list)

Description: n/a

### <a name="output_private_ip_address_list"></a> [private\_ip\_address\_list](#output\_private\_ip\_address\_list)

Description: n/a

### <a name="output_public_ip_address_list"></a> [public\_ip\_address\_list](#output\_public\_ip\_address\_list)

Description: n/a

### <a name="output_virtual_machine_id_list"></a> [virtual\_machine\_id\_list](#output\_virtual\_machine\_id\_list)

Description: n/a
<!-- END_TF_DOCS -->