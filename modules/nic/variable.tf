variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "ip_configurations" {
  description = "IP configs list."
  type = list(object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string
    private_ip_address            = optional(string)
    public_ip_id                  = optional(string)
  }))
}

variable "network_security_group_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
