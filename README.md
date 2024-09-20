### Terraform Module and Terraform Cloud with Azurerm

### Todo list
- 간단한 테스트 용도 vm,network,lb 배포 모듈 개발
- vm,db,appservice,aks,network 모듈 개발, 고도화

### TFC Azurerm Module (Archive)

- [terraform-azurerm-network](https://registry.terraform.io/modules/hyukjuns/network/azurerm/latest)
- [terraform-azurerm-nsg](https://registry.terraform.io/modules/hyukjuns/nsg/azurerm/latest)
- [terraform-azurerm-pip](https://registry.terraform.io/modules/hyukjuns/public-ip/azurerm/latest)
- [terraform-azurerm-linux](https://registry.terraform.io/modules/hyukjuns/linux/azurerm/latest)

### Terraform Cloud (Archive)
- [Terraform Cloud Usage](https://github.com/hyukjuns/terraform-cloud-usage)

### Cheatseets

```markdown
# tfstate backends - azurerm (blob)

  terraform {
    required_providers {
          azurerm = {
          source  = "hashicorp/azurerm"
          version = "~> 4.0"
        }
    }
    backend "azurerm" {
            resource_group_name  = "RGNAME"
            storage_account_name = "SACNAME"
            container_name       = "CONTAINER_NAME"
            key                  = "STATE_FILE"
        }
  }


# terraform version 4.x 중요 변경 사항

provider block에 subscription_id 입력 필요 
혹은 환경변수로 세팅 환경변수: ARM_SUBSCRIPTION_ID


# module repo naming convention
terraform-<PROVIDER>-<MODULENAME>

# markdown document 형식으로 정리 - terraform-docs
terraform-docs markdown document . --output-file README.md

# markdown table 형식으로 정리
terraform-docs markdown table . --output-file README.md --sort-by required

# for_each input
for_each: set과 map 형식만 input으로 사용 가능

# map, set 참조
output "subnet_ids" {
  value = {
    for value in azurerm_subnet.network : value.name => value.id
  }
}

# for_each 인풋 중 set 자료형의 인자값으로 null 사용 못함
"for_each" sets must not contain null values.

# list에서 null 값 제거
> compact(local.public_ip_enabled)
tolist([
  "test1",
])
```

### Ref
- [Terraform Environment Variables](https://www.terraform.io/cli/config/environment-variables)
- [모듈 문서화 툴](https://github.com/terraform-docs/terraform-docs)
