provider "azurerm" {
  features {}

  use_oidc = true
}

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
