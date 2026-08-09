resource_group_name = "iad-az-prod-rg"
key_vault_name      = "iad-az-prod-kv-2026"
location            = "centralindia"
vnet_name           = "iad-az-prod-vnet"
address_space       = "10.1.0.0/16"
vm_size             = "Standard_B2s"
vm_admin_username   = "azureuser"
vm_admin_password   = "P@ssw0rdProd123456!"

tags = {
  environment = "prod"
  project     = "iad-az-prod-landing-zone"
}
