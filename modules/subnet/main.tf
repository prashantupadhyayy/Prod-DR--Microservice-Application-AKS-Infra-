locals {
  enable_private_link = coalesce(var.enforce_private_link_endpoint_network_policies, true)
}

resource "azurerm_subnet" "subnet" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = var.service_endpoints

  # Minimum required delegation block to avoid Terraform v4 errors
  delegation {
    name = "default"
    service_delegation {
      name    = "Microsoft.Network/virtualNetworks"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  count                     = var.nsg_id == null ? 0 : 1
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_subnet_route_table_association" "rt" {
  count          = var.route_table_id == null ? 0 : 1
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = var.route_table_id
}
