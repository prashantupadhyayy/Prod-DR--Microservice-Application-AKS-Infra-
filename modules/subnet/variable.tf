variable "name" {
  type        = string
  description = "Subnet name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group of the VNet."
}

variable "virtual_network_name" {
  type        = string
  description = "Parent VNet name."
}

variable "address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the subnet."
}

variable "service_endpoints" {
  type        = list(string)
  description = "Service endpoints to associate."
  default     = []
}

variable "nsg_id" {
  type        = string
  description = "Network Security Group ID to associate."
  default     = null
}

variable "route_table_id" {
  type        = string
  description = "Route table ID to associate."
  default     = null
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  description = "Whether to enable/disable private link policies."
  default     = true
}
