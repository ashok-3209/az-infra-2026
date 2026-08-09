locals {
  resource_groups = {
    iad_az_prod = {
      name     = var.resource_group_name
      location = var.location
      tags     = var.tags
    }
  }

  virtual_networks = {
    iad_az_prod = {
      name                = var.vnet_name
      address_space       = [var.address_space]
      resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
      location            = module.resource_group.resource_group_locations["iad_az_prod"]
    }
  }

  subnets = {
    appgw = {
      name                 = "iad-az-prod-appgw-subnet"
      prefix               = "10.1.0.0/24"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_prod"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_prod"]
    }
    frontend = {
      name                 = "iad-az-prod-frontend-subnet"
      prefix               = "10.1.1.0/24"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_prod"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_prod"]
    }
    backend = {
      name                 = "iad-az-prod-backend-subnet"
      prefix               = "10.1.2.0/24"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_prod"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_prod"]
    }
    database = {
      name                 = "iad-az-prod-database-subnet"
      prefix               = "10.1.3.0/24"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_prod"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_prod"]
    }
    bastion = {
      name                 = "AzureBastionSubnet"
      prefix               = "10.1.4.0/26"
      virtual_network_name = module.virtual_network.virtual_network_names["iad_az_prod"]
      resource_group_name  = module.resource_group.resource_group_names["iad_az_prod"]
    }
  }

  public_ips = {
    bastion = {
      name                = "iad-az-prod-bastion-pip"
      location            = module.resource_group.resource_group_locations["iad_az_prod"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
      allocation_method   = "Static"
      sku                 = "Standard"
    }
    appgw = {
      name                = "iad-az-prod-appgw-pip"
      location            = module.resource_group.resource_group_locations["iad_az_prod"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
      allocation_method   = "Static"
      sku                 = "Standard"
    }
  }

  vms = {
    frontend_vm1 = {
      name                = "iad-az-prod-vm-frontend-1"
      location            = module.resource_group.resource_group_locations["iad_az_prod"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
      subnet_id           = module.subnets.subnet_ids["frontend"]
      size                = var.vm_size
      admin_username      = var.vm_admin_username
      admin_password      = var.vm_admin_password
      tier                = "frontend"
    }
    frontend_vm2 = {
      name                = "iad-az-prod-vm-frontend-2"
      location            = module.resource_group.resource_group_locations["iad_az_prod"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
      subnet_id           = module.subnets.subnet_ids["frontend"]
      size                = var.vm_size
      admin_username      = var.vm_admin_username
      admin_password      = var.vm_admin_password
      tier                = "frontend"
    }
    backend_vm1 = {
      name                = "iad-az-prod-vm-backend-1"
      location            = module.resource_group.resource_group_locations["iad_az_prod"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
      subnet_id           = module.subnets.subnet_ids["backend"]
      size                = var.vm_size
      admin_username      = var.vm_admin_username
      admin_password      = var.vm_admin_password
      tier                = "backend"
    }
    backend_vm2 = {
      name                = "iad-az-prod-vm-backend-2"
      location            = module.resource_group.resource_group_locations["iad_az_prod"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
      subnet_id           = module.subnets.subnet_ids["backend"]
      size                = var.vm_size
      admin_username      = var.vm_admin_username
      admin_password      = var.vm_admin_password
      tier                = "backend"
    }
    database_vm1 = {
      name                = "iad-az-prod-vm-database-1"
      location            = module.resource_group.resource_group_locations["iad_az_prod"]
      resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
      subnet_id           = module.subnets.subnet_ids["database"]
      size                = var.vm_size
      admin_username      = var.vm_admin_username
      admin_password      = var.vm_admin_password
      tier                = "database"
    }
  }
}

# Child Module 1: Resource Group
module "resource_group" {
  source          = "../../module/azure_resource_group"
  resource_groups = local.resource_groups
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

# Child Module 5: Virtual Machines
module "virtual_machine" {
  source     = "../../module/azure_virtual_machine"
  vms        = local.vms
  depends_on = [module.subnets]
}

# Child Module 6: Azure Bastion Host
module "bastion" {
  source               = "../../module/azure_bastion"
  name                 = "iad-az-prod-bastion"
  location             = module.resource_group.resource_group_locations["iad_az_prod"]
  resource_group_name  = module.resource_group.resource_group_names["iad_az_prod"]
  subnet_id            = module.subnets.subnet_ids["bastion"]
  public_ip_address_id = module.public_ip.public_ip_ids["bastion"]
  depends_on           = [module.public_ip, module.subnets]
}

# Child Module 7: Azure Application Gateway
module "app_gateway" {
  source               = "../../module/azure_app_gateway"
  name                 = "iad-az-prod-appgw"
  location             = module.resource_group.resource_group_locations["iad_az_prod"]
  resource_group_name  = module.resource_group.resource_group_names["iad_az_prod"]
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
  name                = "iad-az-prod-backend-lb"
  location            = module.resource_group.resource_group_locations["iad_az_prod"]
  resource_group_name = module.resource_group.resource_group_names["iad_az_prod"]
  subnet_id           = module.subnets.subnet_ids["backend"]
  backend_nic_ids     = {
    backend_vm1 = module.virtual_machine.vm_nic_ids["backend_vm1"],
    backend_vm2 = module.virtual_machine.vm_nic_ids["backend_vm2"]
  }
  depends_on = [module.virtual_machine, module.subnets]
}
