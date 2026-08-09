output "resource_group_names" {
  description = "Map of resource group names."
  value       = { for k, rg in azurerm_resource_group.rgs : k => rg.name }
}

output "resource_group_locations" {
  description = "Map of resource group locations."
  value       = { for k, rg in azurerm_resource_group.rgs : k => rg.location }
}
