variable "name" {
  type        = string
  description = "Name of the virtual network."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the VNet."
}

# variable "dns_servers" {
#   type        = list(string)
#   description = "Custom DNS servers for the VNet."
#   default     = []
# }

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VNet."
  default     = {}
}
