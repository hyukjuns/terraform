variable "my_admin_username" {
  type        = string
  description = "가상머신 유저 이름"
}
variable "my_admin_password" {
  type        = string
  description = "가상머신 유저 암호"
}

variable "my_subnet_id" {
  type        = string
  description = "서브넷 아이디"
}