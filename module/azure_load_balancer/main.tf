resource "azurerm_lb" "internal_lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = "internal-lb-frontend-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "lb_pool" {
  loadbalancer_id = azurerm_lb.internal_lb.id
  name            = "backend-pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  for_each                = var.backend_nic_ids
  network_interface_id    = each.value
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_pool.id
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.internal_lb.id
  name            = "http-probe"
  port            = var.backend_port
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.internal_lb.id
  name                           = "internal-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "internal-lb-frontend-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}
