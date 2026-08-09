variable "key_vault_name" {
  description = "Name of the Azure Key Vault."
  type        = string
}

variable "location" {
  description = "Azure region location."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group."
  type        = string
}

variable "admin_username" {
  description = "VM Administrator username to store in Key Vault."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "VM Administrator password to store in Key Vault."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags for Key Vault."
  type        = map(string)
  default     = {}
}
