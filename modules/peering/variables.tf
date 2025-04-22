variable "resource_group_name" {
  type        = string
  description = "리소스 그룹 이름"
}

# vnet 1
variable "source_vnet_name" {
  type        = string
  description = "Peering VNET 이름 1"
}
variable "source_vnet_id" {
  type        = string
  description = "Peering VNET ID 1"
}

# vnet 2
variable "remote_vnet_name" {
  type        = string
  description = "Peering VNET 이름 2"
}
variable "remote_vnet_id" {
  type        = string
  description = "Peering VNET ID 2"
}