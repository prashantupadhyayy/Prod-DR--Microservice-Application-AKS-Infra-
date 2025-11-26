output "id" {
  value = azurerm_storage_account.storage_account.id
}

output "primary_connection_string" {
  value     = azurerm_storage_account.this.primary_connection_string
  sensitive = true
}
