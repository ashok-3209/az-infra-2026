variable "subnets" {
  description = "Map of subnets to create."
  type = map(object({
    name                 = string
    prefix               = string
    virtual_network_name = string
    resource_group_name  = string
  }))
}
