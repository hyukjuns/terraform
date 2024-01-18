variable "prefix" {
  description = "prefix"
  default     = "dev"
}

variable "resource_group_name" {
  description = "resource group name"
  default     = "aks-terraform"
}

variable "location" {
  description = "location"
  default     = "koreacentral"
}

variable "k8s_version" {
  description = "kubernetes version"
  default     = "1.26.6"
}