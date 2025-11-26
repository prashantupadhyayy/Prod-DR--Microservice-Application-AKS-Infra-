variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "version" {
  type    = string
  default = "12.0"
}

variable "administrator_login" {
  type      = string
  sensitive = true
}

variable "administrator_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
