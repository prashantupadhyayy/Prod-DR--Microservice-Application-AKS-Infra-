## Common Variables
variable "location" {
  description = "The Azure Region to deploy resources."
  type        = string
}

variable "common_tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
}

## Resource Definitions (Map of Objects)

# Resource Groups
variable "resource_groups" {
  description = "Map of resource group configurations."
  type = map(object({
    name     = string
    location = string
  }))
}

# Log Analytics Workspaces
variable "log_analytics_workspaces" {
  description = "Map of log analytics workspace configurations."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    retention_in_days   = number
  }))
}

# Container Registries
variable "container_registries" {
  description = "Map of ACR configurations."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = string
    admin_enabled       = bool
  }))
}

# Virtual Networks
variable "virtual_networks" {
  description = "Map of VNet configurations."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    #dns_servers         = list(string)
  }))
}

# Subnets
variable "subnets" {
  description = "Map of Subnet configurations."
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
    service_endpoints    = list(string)
    # The delegation is hardcoded in main.tf as per your structure
  }))
}

# Subnet NSG Associations (To associate a subnet with an NSG)
variable "subnet_nsg_associations" {
  description = "Map of Subnet to NSG associations."
  type = map(object({
    subnet_id = string
    nsg_id    = string
  }))
  default = {}
}

# Network Security Groups
variable "network_security_groups" {
  description = "Map of NSG configurations."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

# Public IPs
variable "public_ips" {
  description = "Map of Public IP configurations."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    sku                 = string
  }))
}

# Network Interfaces
variable "network_interfaces" {
  description = "Map of NIC configurations."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    ip_configurations = list(object({
      name                          = string
      subnet_id                     = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
      public_ip_id                  = optional(string)
    }))
  }))
}

# Kubernetes Clusters (AKS)
variable "kubernetes_clusters" {
  description = "Map of AKS cluster configurations."
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    dns_prefix                 = string
    kubernetes_version         = optional(string) # Used in locals
    identity_type              = string
    log_analytics_workspace_id = string # Should be ID output from LA workspace
    default_node_pool = object({
      name           = string
      vm_size        = string
      node_count     = number
      vnet_subnet_id = string
      max_pods       = optional(number)
    })
  }))
}

# Application Gateways
variable "application_gateways" {
  description = "Map of App Gateway configurations."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })
    gateway_subnet_id = string
    frontend_ip_config = object({
      name         = string
      public_ip_id = optional(string)
      subnet_id    = optional(string)
    })
    frontend_port = object({
      name = string
      port = number
    })
    backend_pool_name = string
    http_settings = object({
      name                  = string
      port                  = number
      protocol              = string
      cookie_based_affinity = optional(string)
    })
    listener = object({
      name               = string
      frontend_ip_name   = string
      frontend_port_name = string
      protocol           = string
    })
    routing_rule = object({
      name               = string
      listener_name      = string
      backend_pool_name  = string
      http_settings_name = string
    })
  }))
}

# MSSQL Servers
variable "mssql_servers" {
  description = "Map of MSSQL Server configurations."
  type = map(object({
    name                   = string
    resource_group_name    = string
    location               = string
    version                = string
    administrator_login    = string
    administrator_password = string # Sensitive
  }))
}

# MSSQL Databases
variable "mssql_databases" {
  description = "Map of MSSQL Database configurations."
  type = map(object({
    name        = string
    server_id   = string
    max_size_gb = number
    sku_name    = string
  }))
}

# Storage Accounts
variable "storage_accounts" {
  description = "Map of Storage Account configurations."
  type = map(object({
    name                     = string
    location                 = string
    resource_group_name      = string
    account_tier             = string
    account_replication_type = string
    account_kind             = string
  }))
}

# Traffic Manager Profiles
# variable "traffic_manager_profiles" {
#   description = "Map of Traffic Manager Profile configurations."
#   type = map(object({
#     name                = string
#     resource_group_name = string
#     routing_method      = string
#     profile_status      = string
#     dns_config = object({
#       relative_name = string
#       ttl           = number
#     })
#     monitor_config = object({
#       protocol = string
#       port     = number
#       path     = string
#     })
#   }))
# }

# Traffic Manager Endpoints
# variable "traffic_manager_endpoints" {
#   description = "Map of Traffic Manager Endpoint configurations."
#   type = map(object({
#     name              = string
#     profile_id        = string
#     endpoint_type     = string
#     target            = string
#     endpoint_location = optional(string)
#     priority          = optional(number)
#   }))
# }

# DNS CNAME Records
# variable "dns_cname_records" {
#   description = "Map of DNS CNAME record configurations."
#   type = map(object({
#     name                = string
#     zone_name           = string
#     resource_group_name = string
#     ttl                 = number
#     target_resource_id  = string
#   }))
# }

# Monitor Action Groups
variable "monitor_action_groups" {
  description = "Map of Monitor Action Group configurations."
  type = map(object({
    name                = string
    resource_group_name = string
    short_name          = string
    email               = string
  }))
}

# Monitor Metric Alerts
variable "monitor_metric_alerts" {
  description = "Map of Monitor Metric Alert configurations."
  type = map(object({
    name                = string
    resource_group_name = string
    scopes              = list(string)
    severity            = number
    frequency           = string
    window_size         = string
    action_group_id     = string # Should be ID output from Monitor Action Group
    criteria = object({
      metric_name      = string
      metric_namespace = string
      operator         = string
      threshold        = number
      aggregation_type = string
    })
  }))
}