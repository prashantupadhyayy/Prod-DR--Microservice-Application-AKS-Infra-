variable "name" {
  type        = string
  description = "Alert name"
}

variable "resource_group_name" {
  type        = string
}

variable "scope" {
  type        = string
  description = "Resource ID this alert monitors"
}

variable "severity" {
  type        = number
}

variable "metric_namespace" {
  type        = string
}

variable "metric_name" {
  type        = string
}

variable "operator" {
  type        = string
}

variable "threshold" {
  type        = number
}

variable "aggregation_type" {
  type        = string
}

variable "frequency" {
  type        = string
}

variable "window_size" {
  type        = string
}

variable "email" {
  type        = string
  description = "Alert receiver email address"
}

variable "tags" {
  type    = map(string)
  default = {}
}
