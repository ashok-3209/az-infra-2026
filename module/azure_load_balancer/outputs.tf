output "load_balancer_id" {
  description = "The ID of the internal load balancer."
  value       = azurerm_lb.internal_lb.id
}

output "private_ip_address" {
  description = "The private IP address of the internal load balancer."
  value       = azurerm_lb.internal_lb.frontend_ip_configuration[0].private_ip_address
}
