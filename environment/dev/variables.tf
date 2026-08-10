variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "iad-az-dev-rg"
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "iad-az-dev-vnet"
}

variable "location" {
  description = "Azure location for resources."
  type        = string
  default     = "centralindia"
}

variable "tags" {
  description = "Tags to apply to the resource group."
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "iad-az-dev-landing-zone"
  }
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "vm_admin_username" {
  description = "Admin username for the Linux VMs."
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Admin password for the Linux VMs (leave empty to auto-generate in Key Vault)."
  type        = string
  sensitive   = true
  default     = ""
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault."
  type        = string
  default     = "iad-az-dev-kv-2026"
}

