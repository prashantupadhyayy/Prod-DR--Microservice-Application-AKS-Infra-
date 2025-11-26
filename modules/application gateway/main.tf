resource "azurerm_application_gateway" "appgw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.gateway_subnet_id
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_config.name
    public_ip_address_id = try(var.frontend_ip_config.public_ip_id, null)
    subnet_id            = try(var.frontend_ip_config.subnet_id, null)
  }

  frontend_port {
    name = var.frontend_port.name
    port = var.frontend_port.port
  }

  backend_address_pool {
    name = var.backend_pool_name
  }

  backend_http_settings {
    name                  = var.http_settings.name
    port                  = var.http_settings.port
    protocol              = var.http_settings.protocol
    cookie_based_affinity = lookup(var.http_settings, "cookie_based_affinity", "Disabled")
  }

  http_listener {
    name                           = var.listener.name
    frontend_ip_configuration_name = var.listener.frontend_ip_name
    frontend_port_name             = var.listener.frontend_port_name
    protocol                       = var.listener.protocol
  }

  request_routing_rule {
    name                       = var.routing_rule.name
    rule_type                  = "Basic"
    http_listener_name         = var.routing_rule.listener_name
    backend_address_pool_name  = var.routing_rule.backend_pool_name
    backend_http_settings_name = var.routing_rule.http_settings_name
  }

  tags = var.tags
}
