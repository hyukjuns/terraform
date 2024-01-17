# Azure Resource samples
Azure 리소스 샘플 저장소
## Versions
### Terraform
- ```terraform core: ~> 1.3.0```
### Providers

- ```azurerm: ~> 3.0```

## Backends
1. azurerm (blob)
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
2. tfc

### Ref
- [Terraform Environment Variables](https://www.terraform.io/cli/config/environment-variables)