output "vm_nic_ids" {
  description = "Map of network interface IDs."
  value       = { for k, nic in azurerm_network_interface.nics : k => nic.id }
}

output "vm_private_ip_addresses" {
  description = "Map of VM private IP addresses."
  value       = { for k, nic in azurerm_network_interface.nics : k => nic.private_ip_address }
}

output "vm_names" {
  description = "List of created VM names."
  value       = [for vm in azurerm_linux_virtual_machine.linux_vms : vm.name]
}
