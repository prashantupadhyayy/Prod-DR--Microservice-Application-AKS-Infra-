variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "target_resource_id" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "record_type" {
  type    = string
  default = "CNAME"
}

variable "ttl" {
  type    = number
  default = 300
}
