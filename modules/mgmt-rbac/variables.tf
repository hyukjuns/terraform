variable "user_password" {
  description = "User Password"
}
variable "email_address" {
  description = "primary domain name"
}
variable "external_user" {
  description = "external user"
}

variable "azure_roles" {
  type = map(any)
  default = {
    Owner       = "Owner"
    Contributor = "Contributor"
    Reader      = "Reader"
  }
}