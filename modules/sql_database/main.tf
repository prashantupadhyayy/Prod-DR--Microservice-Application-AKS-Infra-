resource "azurerm_mssql_database" "sql_database" {
  name           = var.name
  server_id      = var.server_id
  max_size_gb    = var.max_size_gb
  sku_name       = var.sku_name
  zone_redundant = false

  tags = var.tags
}
