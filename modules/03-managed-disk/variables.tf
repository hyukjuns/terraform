variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}
variable "resource_group_location" {
  type        = string
  description = "Resource Group Location"
}
variable "data_disks" {
  type = list(object(
    {
      name                 = string
      storage_account_type = optional(string)
      create_option        = optional(string)
      disk_size_gb         = string
      vm_id                = string
      lun                  = string
      caching              = optional(string)
    }
  ))
  description = "Data Disk Info"
}