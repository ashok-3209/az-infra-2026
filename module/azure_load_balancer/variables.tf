variable "name" {
  description = "Load balancer name."
  type        = string
}

variable "location" {
  description = "Azure Region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "sku" {
  description = "Load balancer SKU."
  type        = string
  default     = "Standard"
}

variable "subnet_id" {
  description = "Subnet ID for internal load balancer."
  type        = string
}

variable "backend_nic_ids" {
  description = "Map of backend NIC IDs to associate with pool."
  type        = map(string)
}

variable "frontend_port" {
  description = "Frontend port."
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend port."
  type        = number
  default     = 80
}
