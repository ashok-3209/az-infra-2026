output "public_ip_ids" {
  description = "Map of public IP IDs."
  value       = { for k, pip in azurerm_public_ip.public_ips : k => pip.id }
}

output "public_ip_addresses" {
  description = "Map of public IP addresses."
  value       = { for k, pip in azurerm_public_ip.public_ips : k => pip.ip_address }
}
