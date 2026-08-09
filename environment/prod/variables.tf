variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "iad-az-prod-rg"
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "iad-az-prod-vnet"
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
    environment = "prod"
    project     = "iad-az-prod-landing-zone"
  }
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = string
  default     = "10.1.0.0/16"
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_B2s"
}

variable "vm_admin_username" {
  description = "Admin username for the Linux VMs."
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Admin password for the Linux VMs."
  type        = string
  sensitive   = true
  default     = "P@ssw0rdProd123456!"
}
