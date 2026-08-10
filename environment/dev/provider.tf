terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "az-rg-devops01"
    storage_account_name = "azstgdevops01"
    container_name       = "azstgdevcontainer"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "56d4ebce-52e4-4807-ac43-48cb1bef8c71"
  tenant_id       = "a23c2c3a-6efd-4ce4-8b04-645bc2552e51"
  client_id       = "62d53dac-54da-4d6d-a140-767685b48833"

  use_oidc = true
}
