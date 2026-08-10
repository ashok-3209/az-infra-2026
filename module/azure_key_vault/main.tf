data "azurerm_client_config" "current" {}

# Data source to fetch the existing Key Vault
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

# Data source to fetch the admin username secret
data "azurerm_key_vault_secret" "admin_username" {
  name         = var.admin_username_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

# Data source to fetch the admin password secret
data "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}
