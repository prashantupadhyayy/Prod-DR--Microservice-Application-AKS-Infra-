resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind

  min_tls_version = "TLS1_2"

  tags = var.tags
}
