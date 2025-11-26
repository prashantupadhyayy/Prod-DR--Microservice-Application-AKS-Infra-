locals {
  k8s_version = coalesce(var.kubernetes_version, null)
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = var.default_node_pool.name
    vm_size             = var.default_node_pool.vm_size
    node_count          = var.default_node_pool.node_count
    vnet_subnet_id      = var.default_node_pool.vnet_subnet_id
    max_pods            = try(var.default_node_pool.max_pods, null)
    orchestrator_version = coalesce(try(each.value.kubernetes_version, null), null)
  }

  identity {
    type = var.identity_type
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = var.tags
}
