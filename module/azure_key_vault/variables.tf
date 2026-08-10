variable "key_vault_name" {
  description = "Name of the existing Azure Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where Key Vault exists."
  type        = string
}

variable "admin_username_secret_name" {
  description = "Name of the secret in Key Vault that contains the admin username."
  type        = string
  default     = "admin-username"
}

variable "admin_password_secret_name" {
  description = "Name of the secret in Key Vault that contains the admin password."
  type        = string
  default     = "admin-password"
}
