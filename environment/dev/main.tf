locals {
  resource_groups = {
    iad_az_dev = {
      name     = var.resource_group_name
      location = var.location
      tags     = var.tags
    }
  }

  virtual_networks = {
    iad_az_dev = {
      name                = var.vnet_name
      address_space       = [var.address_space]
      resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
      location            = module.resource_group.resource_group_locations["iad_az_dev"]
    }
  }

  subnets = {
    appgw = {
      name                 = "iad-az-dev-appgw-subnet"
      prefix               = "10.0.0.0/24"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_dev"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_dev"]
    }
    frontend = {
      name                 = "iad-az-dev-frontend-subnet"
      prefix               = "10.0.1.0/24"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_dev"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_dev"]
    }
    backend = {
      name                 = "iad-az-dev-backend-subnet"
      prefix               = "10.0.2.0/24"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_dev"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_dev"]
    }
    database = {
      name                 = "iad-az-dev-database-subnet"
      prefix               = "10.0.3.0/24"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_dev"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_dev"]
    }
    bastion = {
      name                 = "AzureBastionSubnet"
      prefix               = "10.0.4.0/26"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_dev"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_dev"]
    }
  }

  public_ips = {
    bastion = {
      name                = "iad-az-dev-bastion-pip"
      location            = module.resource_group.resource_group_locations["iad_az_dev"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
      allocation_method   = "Static"
      sku                 = "Standard"
    }
    appgw = {
      name                = "iad-az-dev-appgw-pip"
      location            = module.resource_group.resource_group_locations["iad_az_dev"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
      allocation_method   = "Static"
      sku                 = "Standard"
    }
  }

  vms = {
    frontend_vm1 = {
      name                = "iad-az-dev-vm-frontend-1"
      location            = module.resource_group.resource_group_locations["iad_az_dev"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
      subnet_id           = module.subnets.subnet_ids["frontend"]
      size                = var.vm_size
      admin_username      = module.key_vault.admin_username_secret_value
      admin_password      = module.key_vault.admin_password_secret_value
      tier                = "frontend"
    }
    frontend_vm2 = {
      name                = "iad-az-dev-vm-frontend-2"
      location            = module.resource_group.resource_group_locations["iad_az_dev"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
      subnet_id           = module.subnets.subnet_ids["frontend"]
      size                = var.vm_size
      admin_username      = module.key_vault.admin_username_secret_value
      admin_password      = module.key_vault.admin_password_secret_value
      tier                = "frontend"
    }
    backend_vm1 = {
      name                = "iad-az-dev-vm-backend-1"
      location            = module.resource_group.resource_group_locations["iad_az_dev"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
      subnet_id           = module.subnets.subnet_ids["backend"]
      size                = var.vm_size
      admin_username      = module.key_vault.admin_username_secret_value
      admin_password      = module.key_vault.admin_password_secret_value
      tier                = "backend"
    }
    backend_vm2 = {
      name                = "iad-az-dev-vm-backend-2"
      location            = module.resource_group.resource_group_locations["iad_az_dev"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
      subnet_id           = module.subnets.subnet_ids["backend"]
      size                = var.vm_size
      admin_username      = module.key_vault.admin_username_secret_value
      admin_password      = module.key_vault.admin_password_secret_value
      tier                = "backend"
    }
    database_vm1 = {
      name                = "iad-az-dev-vm-database-1"
      location            = module.resource_group.resource_group_locations["iad_az_dev"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
      subnet_id           = module.subnets.subnet_ids["database"]
      size                = var.vm_size
      admin_username      = module.key_vault.admin_username_secret_value
      admin_password      = module.key_vault.admin_password_secret_value
      tier                = "database"
    }
  }
}

# Child Module 1: Resource Group
module "resource_group" {
  source          = "../../module/azure_resource_group"
  resource_groups = local.resource_groups
}

# Child Module: Azure Key Vault (Secret storage for VM credentials)
module "key_vault" {
  source              = "../../module/azure_key_vault"
  key_vault_name      = var.key_vault_name
  location            = module.resource_group.resource_group_locations["iad_az_dev"]
  resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  tags                = var.tags
  depends_on          = [module.resource_group]
}

# Child Module 2: Virtual Network
module "virtual_network" {
  source           = "../../module/azure_virtual_network"
  virtual_networks = local.virtual_networks
  depends_on       = [module.resource_group]
}

# Child Module 3: Subnets
module "subnets" {
  source     = "../../module/azure_virtual_subnet"
  subnets    = local.subnets
  depends_on = [module.virtual_network]
}

# Child Module 4: Public IPs
module "public_ip" {
  source     = "../../module/azure_public_ip"
  public_ips = local.public_ips
  depends_on = [module.resource_group]
}

# Child Module 5: Virtual Machines (5 VMs, credentials fetched from Key Vault secrets)
module "virtual_machine" {
  source     = "../../module/azure_virtual_machine"
  vms        = local.vms
  depends_on = [module.subnets, module.key_vault]
}

# Child Module 6: Azure Bastion Host
module "bastion" {
  source               = "../../module/azure_bastion"
  name                 = "iad-az-dev-bastion"
  location             = module.resource_group.resource_group_locations["iad_az_dev"]
  resource_group_name  = module.resource_group.resource_group_names["iad_az_dev"]
  subnet_id            = module.subnets.subnet_ids["bastion"]
  public_ip_address_id = module.public_ip.public_ip_ids["bastion"]
  depends_on           = [module.public_ip, module.subnets]
}

# Child Module 7: Azure Application Gateway
module "app_gateway" {
  source               = "../../module/azure_app_gateway"
  name                 = "iad-az-dev-appgw"
  location             = module.resource_group.resource_group_locations["iad_az_dev"]
  resource_group_name  = module.resource_group.resource_group_names["iad_az_dev"]
  subnet_id            = module.subnets.subnet_ids["appgw"]
  public_ip_address_id = module.public_ip.public_ip_ids["appgw"]
  backend_ip_addresses = [
    module.virtual_machine.vm_private_ip_addresses["frontend_vm1"],
    module.virtual_machine.vm_private_ip_addresses["frontend_vm2"]
  ]
  depends_on = [module.virtual_machine, module.public_ip, module.subnets]
}

# Child Module 8: Azure Internal Load Balancer
module "load_balancer" {
  source              = "../../module/azure_load_balancer"
  name                = "iad-az-dev-backend-lb"
  location            = module.resource_group.resource_group_locations["iad_az_dev"]
  resource_group_name = module.resource_group.resource_group_names["iad_az_dev"]
  subnet_id           = module.subnets.subnet_ids["backend"]
  backend_nic_ids     = {
    backend_vm1 = module.virtual_machine.vm_nic_ids["backend_vm1"],
    backend_vm2 = module.virtual_machine.vm_nic_ids["backend_vm2"]
  }
  depends_on = [module.virtual_machine, module.subnets]
}
