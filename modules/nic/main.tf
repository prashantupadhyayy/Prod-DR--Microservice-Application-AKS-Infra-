resource "azurerm_network_interface" "nic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "ip_configuration" {
    for_each = var.ip_configurations
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation

      private_ip_address = try(ip_configuration.value.private_ip_address, null)
      public_ip_address_id = try(ip_configuration.value.public_ip_id, null)
    }
  }
}

resource "azurerm_network_interface_security_group_association" "nsg" {
  count                     = var.network_security_group_id == null ? 0 : 1
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.network_security_group_id
}
