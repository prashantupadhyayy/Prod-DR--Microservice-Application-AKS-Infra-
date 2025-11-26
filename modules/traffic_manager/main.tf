resource "azurerm_traffic_manager_profile" "traffic_manager" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  traffic_routing_method  = var.routing_method
  profile_status          = var.profile_status

  dns_config {
    relative_name = var.dns_config.relative_name
    ttl           = var.dns_config.ttl
  }

  monitor_config {
    protocol = var.monitor_config.protocol
    port     = var.monitor_config.port
    path     = var.monitor_config.path
  }

  tags = var.tags
}

resource "azurerm_traffic_manager_endpoint" "endpoint" {
  name                      = var.endpoint.name
  profile_id                = azurerm_traffic_manager_profile.traffic_manager.id
  type                      = var.endpoint.endpoint_type
  target                    = var.endpoint.target
  endpoint_location         = try(var.endpoint.endpoint_location, null)
  priority                  = try(var.endpoint.priority, null)
}
