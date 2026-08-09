variable "virtual_networks" {
  description = "Map of virtual networks to create."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
  }))
}
