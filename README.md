### Terraform Module and Terraform Cloud with Azurerm

### Todo
- NSG 모듈 완성
- for / for_each 문 표준화
- 전체 모듈 컨벤션 통일

### Azurerm Module
- Network
- Compute
- Database

### Terraform Cloud 
- [Terraform Cloud Usage](https://github.com/hyukjuns/terraform-cloud-usage)

### TIP
```
### 모듈 문서화 툴
https://github.com/terraform-docs/terraform-docs
# markdown document 형식으로 정리
terraform-docs markdown document . --output-file README.md

# markdown table 형식으로 정리
terraform-docs markdown table . --output-file README.md --sort-by required

### for_each input
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