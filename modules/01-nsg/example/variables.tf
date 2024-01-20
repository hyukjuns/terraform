variable "my_subnet_ids" {
  type        = list(string)
  description = "NSG 연결할 Subnet ID 목록"
}

variable "my_nic_ids" {
  type        = list(string)
  description = "NSG 연결할 NIC ID 목록"
}