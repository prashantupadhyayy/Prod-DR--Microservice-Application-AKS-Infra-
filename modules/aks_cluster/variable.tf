variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "default_node_pool" {
  type = object({
    name            = string
    vm_size         = string
    node_count      = number
    vnet_subnet_id  = string
    max_pods        = optional(number)
  })
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
