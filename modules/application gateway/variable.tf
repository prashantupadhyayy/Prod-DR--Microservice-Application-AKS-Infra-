variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "gateway_subnet_id" {
  type = string
}

variable "frontend_ip_config" {
  type = object({
    name                 = string
    public_ip_id         = optional(string)
    subnet_id            = optional(string)
  })
}

variable "frontend_port" {
  type = object({
    name = string
    port = number
  })
}

variable "backend_pool_name" {
  type = string
}

variable "http_settings" {
  type = object({
    name                   = string
    port                   = number
    protocol               = string
    cookie_based_affinity  = optional(string)
  })
}

variable "listener" {
  type = object({
    name                   = string
    frontend_ip_name       = string
    frontend_port_name     = string
    protocol               = string
  })
}

variable "routing_rule" {
  type = object({
    name                    = string
    listener_name           = string
    backend_pool_name       = string
    http_settings_name      = string
  })
}

variable "tags" {
  type = map(string)
  default = {}
}
