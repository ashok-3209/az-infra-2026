output "resource_group_names" {
  description = "Resource Group names created by child module."
  value       = module.resource_group.resource_group_names
}

output "virtual_network_names" {
  description = "Virtual Network names created by child module."
  value       = module.virtual_network.virtual_network_names
}

output "subnet_ids" {
  description = "Subnet IDs created by child module."
  value       = module.subnets.subnet_ids
}

output "vm_private_ip_addresses" {
  description = "Private IP addresses for all 5 VMs created by child module."
  value       = module.virtual_machine.vm_private_ip_addresses
}

output "vm_names" {
  description = "List of all created VM names."
  value       = module.virtual_machine.vm_names
}

output "bastion_public_ip" {
  description = "Public IP allocated for Azure Bastion host."
  value       = module.public_ip.public_ip_addresses["bastion"]
}

output "application_gateway_public_ip" {
  description = "Public IP allocated for Azure Application Gateway."
  value       = module.public_ip.public_ip_addresses["appgw"]
}

output "backend_load_balancer_private_ip" {
  description = "Private IP for Internal Load Balancer."
  value       = module.load_balancer.private_ip_address
}

output "key_vault_name" {
  description = "Name of the Azure Key Vault."
  value       = module.key_vault.key_vault_name
}

output "key_vault_id" {
  description = "Resource ID of the Azure Key Vault."
  value       = module.key_vault.key_vault_id
}

output "admin_username_secret_name" {
  description = "Secret name for VM Admin Username."
  value       = module.key_vault.admin_username_secret_name
}

output "admin_password_secret_name" {
  description = "Secret name for VM Admin Password."
  value       = module.key_vault.admin_password_secret_name
}
