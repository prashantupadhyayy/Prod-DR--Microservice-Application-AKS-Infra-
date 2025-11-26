variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "profile_status" {
  type    = string
  default = "Enabled"
}

variable "routing_method" {
  type    = string
}

variable "dns_config" {
  type = object({
    relative_name = string
    ttl           = number
  })
}

variable "monitor_config" {
  type = object({
    protocol = string
    port     = number
    path     = string
  })
}

variable "endpoint" {
  type = object({
    name               = string
    target             = string
    endpoint_location  = optional(string)
    priority           = optional(number)
    endpoint_type      = string
  })
}

variable "tags" {
  type    = map(string)
  default = {}
}
