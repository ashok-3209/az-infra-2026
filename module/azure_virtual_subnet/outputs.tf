output "subnet_ids" {
  description = "Map of subnet IDs."
  value       = { for k, subnet in azurerm_subnet.subnets : k => subnet.id }
}

output "subnet_names" {
  description = "Map of subnet names."
  value       = { for k, subnet in azurerm_subnet.subnets : k => subnet.name }
}
