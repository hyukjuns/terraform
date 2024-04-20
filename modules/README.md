# Azurerm Modules

## Versions
### Terraform
- ```terraform core: ~> 1.3.0```
### Providers

- ```azurerm: ~> 3.0```

## Backends
azurerm (blob)

```
terraform {
required_providers {
    azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 3.0"
    }
}
backend "azurerm" {
        resource_group_name  = "<RGNAME>"
        storage_account_name = "<SACNAME>"
        container_name       = "<CONTAINER_NAME>"
        key                  = "<STATE_FILE>"
    }
}
```

### Ref
- [Terraform Environment Variables](https://www.terraform.io/cli/config/environment-variables)