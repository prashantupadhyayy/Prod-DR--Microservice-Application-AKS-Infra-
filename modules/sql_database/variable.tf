variable "name" {
  type = string
}

variable "server_id" {
  type = string
}

variable "max_size_gb" {
  type    = number
  default = 50
}

variable "sku_name" {
  type    = string
  default = "S0"
}

variable "tags" {
  type    = map(string)
  default = {}
}
