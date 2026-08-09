variable "name" {
  description = "Application Gateway Name."
  type        = string
}

variable "location" {
  description = "Azure Region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name."
  type        = string
}

variable "sku_name" {
  description = "App Gateway SKU Name."
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "App Gateway SKU Tier."
  type        = string
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "Capacity count."
  type        = number
  default     = 2
}

variable "subnet_id" {
  description = "App Gateway Subnet ID."
  type        = string
}

variable "public_ip_address_id" {
  description = "Public IP ID for Application Gateway."
  type        = string
}

variable "backend_ip_addresses" {
  description = "List of target private IP addresses for frontend VMs."
  type        = list(string)
}
