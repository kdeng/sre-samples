variable "project_name" {
  description   = "The name of current infrastructure"
  type          = string
  default       = "kefeng_dev"
}

# variable "project_region" {
#   description   = "The default region to setup jenkins cluster"
#   type          = string
#   default       = "ap-southeast-2"
# }

variable "environment" {
  description   = "Environment of this cluster"
  type          = string
  default       = "dev"
}
