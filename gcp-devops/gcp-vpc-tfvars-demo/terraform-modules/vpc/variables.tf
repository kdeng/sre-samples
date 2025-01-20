variable "project_id" {
  type    = string
}

variable "project_region" {
  type    = string
}

variable "project_cidr" {
  type    = string
}

variable "vpc_network_mtu" {
  type    = number
  default = 1460
}


variable "auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "routing_mode" {
  // REGIONAL or GLOBAL
  type    = string
  default = "REGIONAL"
}
