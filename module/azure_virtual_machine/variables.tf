variable "vms" {
  description = "Map of Linux VMs to create."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    size                = string
    admin_username      = string
    admin_password      = string
  }))
}
