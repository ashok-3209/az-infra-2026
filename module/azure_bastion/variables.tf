variable "name" {
  description = "Bastion host name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name."
  type        = string
}

variable "subnet_id" {
  description = "AzureBastionSubnet ID."
  type        = string
}

variable "public_ip_address_id" {
  description = "Public IP ID for Bastion Host."
  type        = string
}
