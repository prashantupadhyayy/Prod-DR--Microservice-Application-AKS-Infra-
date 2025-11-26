locals {
  # Common tags defined in variables
  common_tags = var.common_tags

  # K8s version for AKS (moved from resource block to locals for consistency)
#   k8s_version = coalesce(var.aks.kubernetes_version, null)
}

# --- Azure Resource Group ---
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
  tags     = local.common_tags
}

# --- Log Analytics Workspace ---
resource "azurerm_log_analytics_workspace" "log_analytics" {
  for_each = var.log_analytics_workspaces

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days
  tags                = local.common_tags
}

# --- Azure Container Registry (ACR) ---
resource "azurerm_container_registry" "acr" {
  for_each = var.container_registries

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku
  admin_enabled       = each.value.admin_enabled
  tags                = local.common_tags
}

# --- Virtual Network (VNet) ---
resource "azurerm_virtual_network" "vnet" {
  for_each = var.virtual_networks

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  #dns_servers         = each.value.dns_servers
  tags                = local.common_tags
}

# --- Subnet ---
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  # Delegation block (Minimum required)
  dynamic "delegation" {
    # Check if the key matches the AKS subnet key defined in your tfvars
    for_each = each.key == "aks_snet" ? [1] : []

    content {
      name = "aks-subnet-delegation"

      service_delegation {
        name    = "Microsoft.ContainerService/managedClusters"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

# --- Network Security Group (NSG) ---
resource "azurerm_network_security_group" "nsg" {
  for_each = var.network_security_groups

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = local.common_tags

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# --- Subnet NSG Association (Requires existing Subnet and NSG) ---
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = {
    for k, v in var.subnet_nsg_associations : k => v
    if v.nsg_id != null
  }

  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.nsg_id
}

# --- Azure Kubernetes Cluster (AKS) ---
resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.kubernetes_clusters

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  tags                = local.common_tags

  default_node_pool {
    name                 = each.value.default_node_pool.name
    vm_size              = each.value.default_node_pool.vm_size
    node_count           = each.value.default_node_pool.node_count
    vnet_subnet_id       = each.value.default_node_pool.vnet_subnet_id
    max_pods             = try(each.value.default_node_pool.max_pods, null)
    orchestrator_version = coalesce(try(each.value.kubernetes_version, null), null)
  }
  

  identity {
    type = each.value.identity_type
  }

  # Log Analytics ID is provided as an output from the Log Analytics block
  oms_agent {
    log_analytics_workspace_id = each.value.log_analytics_workspace_id
  }
}

# --- Public IP (PIP) ---
resource "azurerm_public_ip" "pip" {
  for_each = var.public_ips

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  tags                = local.common_tags
}

# --- Network Interface (NIC) ---
resource "azurerm_network_interface" "nic" {
  for_each = var.network_interfaces

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = local.common_tags

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = try(ip_configuration.value.private_ip_address, null)
      public_ip_address_id          = try(ip_configuration.value.public_ip_id, null)
    }
  }
}

# --- Application Gateway ---
resource "azurerm_application_gateway" "appgw" {
  for_each = var.application_gateways

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = local.common_tags

  sku {
    name     = each.value.sku.name
    tier     = each.value.sku.tier
    capacity = each.value.sku.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = each.value.gateway_subnet_id
  }

  # All other nested blocks (frontend_ip_configuration, frontend_port, etc.) would also be defined using 'dynamic' blocks if multiple instances were needed inside each AppGW.
  # For simplicity, we keep the provided single nested block structure here:
  frontend_ip_configuration {
    name                 = each.value.frontend_ip_config.name
    public_ip_address_id = try(each.value.frontend_ip_config.public_ip_id, null)
    subnet_id            = try(each.value.frontend_ip_config.subnet_id, null)
  }

  frontend_port {
    name = each.value.frontend_port.name
    port = each.value.frontend_port.port
  }

  backend_address_pool {
    name = each.value.backend_pool_name
  }

  backend_http_settings {
    name                  = each.value.http_settings.name
    port                  = each.value.http_settings.port
    protocol              = each.value.http_settings.protocol
    cookie_based_affinity = lookup(each.value.http_settings, "cookie_based_affinity", "Disabled")
  }

  http_listener {
    name                           = each.value.listener.name
    frontend_ip_configuration_name = each.value.listener.frontend_ip_name
    frontend_port_name             = each.value.listener.frontend_port_name
    protocol                       = each.value.listener.protocol
  }

  request_routing_rule {
    name                       = each.value.routing_rule.name
    rule_type                  = "Basic"
    http_listener_name         = each.value.routing_rule.listener_name
    backend_address_pool_name  = each.value.routing_rule.backend_pool_name
    backend_http_settings_name = each.value.routing_rule.http_settings_name
  }
}

# --- MSSQL Server ---
resource "azurerm_mssql_server" "sql_server" {
  for_each = var.mssql_servers

  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_password
  tags                         = local.common_tags
}

# --- MSSQL Database ---
resource "azurerm_mssql_database" "sql_database" {
  for_each = var.mssql_databases

  name           = each.value.name
  server_id      = each.value.server_id
  max_size_gb    = each.value.max_size_gb
  sku_name       = each.value.sku_name
  zone_redundant = false
  tags           = local.common_tags
}

# --- Storage Account ---
resource "azurerm_storage_account" "storage_account" {
  for_each = var.storage_accounts

  name                     = each.value.name
  location                 = each.value.location
  resource_group_name      = each.value.resource_group_name
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  account_kind             = each.value.account_kind
  min_tls_version          = "TLS1_2"
  tags                     = local.common_tags
}

# --- Traffic Manager Profile ---
# resource "azurerm_traffic_manager_profile" "traffic_manager" {
#   for_each = var.traffic_manager_profiles

#   name                    = each.value.name
#   resource_group_name     = each.value.resource_group_name
#   traffic_routing_method  = each.value.routing_method
#   profile_status          = each.value.profile_status
#   tags                    = local.common_tags

#   dns_config {
#     relative_name = each.value.dns_config.relative_name
#     ttl           = each.value.dns_config.ttl
#   }

#   monitor_config {
#     protocol = each.value.monitor_config.protocol
#     port     = each.value.monitor_config.port
#     path     = each.value.monitor_config.path
#   }
# }

# # --- Traffic Manager Endpoint ---
# resource "azurerm_traffic_manager_endpoint" "endpoint" {
#   for_each = var.traffic_manager_endpoints

#   name              = each.value.name
#   profile_id        = each.value.profile_id
#   type              = each.value.endpoint_type
#   target            = each.value.target
#   endpoint_location = try(each.value.endpoint_location, null)
#   priority          = try(each.value.priority, null)
# }

# --- DNS CNAME Record ---
# resource "azurerm_dns_cname_record" "dns" {
#   for_each = var.dns_cname_records

#   name                = each.value.name
#   zone_name           = each.value.zone_name
#   resource_group_name = each.value.resource_group_name
#   ttl                 = each.value.ttl
#   record              = each.value.target_resource_id
# }

# --- Monitor Action Group ---
resource "azurerm_monitor_action_group" "az_monitor" {
  for_each = var.monitor_action_groups

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  short_name          = each.value.short_name
  tags                = local.common_tags

  email_receiver {
    name          = "email-alert"
    email_address = each.value.email
  }
}

# --- Monitor Metric Alert ---
resource "azurerm_monitor_metric_alert" "az_monitoralert" {
  for_each = var.monitor_metric_alerts

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  scopes              = each.value.scopes
  severity            = each.value.severity
  auto_mitigate       = true
  frequency           = each.value.frequency
  window_size         = each.value.window_size
  tags                = local.common_tags

  criteria {
    metric_name      = each.value.criteria.metric_name
    metric_namespace = each.value.criteria.metric_namespace
    operator         = each.value.criteria.operator
    threshold        = each.value.criteria.threshold
    aggregation      = each.value.criteria.aggregation_type
  }

  action {
    action_group_id = each.value.action_group_id
  }
}