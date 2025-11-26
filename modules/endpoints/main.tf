resource "azurerm_dns_cname_record" "dns" {
  name                = var.name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = var.target_resource_id
}
