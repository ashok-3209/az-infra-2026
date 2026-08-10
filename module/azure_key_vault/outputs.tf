output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = data.azurerm_key_vault.kv.id
}

output "key_vault_name" {
  description = "The Name of the Key Vault."
  value       = data.azurerm_key_vault.kv.name
}

output "key_vault_uri" {
  description = "The Vault URI of the Key Vault."
  value       = data.azurerm_key_vault.kv.vault_uri
}

output "admin_username_secret_id" {
  description = "Secret ID of the VM Admin Username."
  value       = data.azurerm_key_vault_secret.admin_username.id
}

output "admin_password_secret_id" {
  description = "Secret ID of the VM Admin Password."
  value       = data.azurerm_key_vault_secret.admin_password.id
}

output "admin_username_secret_name" {
  description = "Secret name of the VM Admin Username."
  value       = data.azurerm_key_vault_secret.admin_username.name
}

output "admin_password_secret_name" {
  description = "Secret name of the VM Admin Password."
  value       = data.azurerm_key_vault_secret.admin_password.name
}

output "admin_username_secret_value" {
  description = "The value of the admin username secret."
  value       = data.azurerm_key_vault_secret.admin_username.value
  sensitive   = true
}

output "admin_password_secret_value" {
  description = "The value of the admin password secret."
  value       = data.azurerm_key_vault_secret.admin_password.value
  sensitive   = true
}
