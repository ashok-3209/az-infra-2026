resource_group_name = "iad-az-dev-rg"
key_vault_name      = "iad-az-dev-kv-2026"
location            = "centralindia"
vnet_name           = "iad-az-dev-vnet"
address_space       = "10.0.0.0/16"
vm_size             = "Standard_D2s_v3"

tags = {
  environment = "dev"
  project     = "iad-az-dev-landing-zone"
  managed_by  = "Infra-Team"
  requested_by = "Dev-Team"
  created_by   = "ashok-devops"
  environment_type = "Development"
  accountable_team = "Dev-Team"
  cost_center      = "CC-12345"
}