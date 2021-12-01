variable "project_id" {
  type = string
}

variable "project_region" {
  type = string
}

variable "project_zones" {
  type    = list(string)
  default = []
}

variable "environment" {
  type    = string
  default = ""
}

variable "instance_name" {
  type    = string
  default = ""
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}

variable "network_id" {
  type    = string
  default = ""
}

variable "public_subnetwork_ids" {
  type    = list(string)
  default = []
}

variable "private_subnetwork_ids" {
  type    = list(string)
  default = []
}
