output "id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID of the virtual network."
}

output "name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Name of the VNet."
}
