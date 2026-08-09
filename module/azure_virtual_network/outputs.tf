output "virtual_network_names" {
  description = "Map of virtual network names."
  value       = { for k, vnet in azurerm_virtual_network.vnets : k => vnet.name }
}

output "virtual_network_ids" {
  description = "Map of virtual network IDs."
  value       = { for k, vnet in azurerm_virtual_network.vnets : k => vnet.id }
}
