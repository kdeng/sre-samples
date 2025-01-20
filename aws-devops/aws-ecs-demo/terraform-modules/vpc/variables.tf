variable "project_name" {
  description   = "The name of current infrastructure"
  type          = string
  default       = "recruitable"
}

variable "project_cidr" {
  description   = "The default region to setup jenkins cluster"
  type          = string
  default       = "10.0.0.0/16"
}

variable "environment" {
  description   = "Environment of this cluster"
  type          = string
  default       = "PROD"
}

variable "vpc_name" {
  description   = "The name of VPC"
  type          = string
  default       = "recruitable-default-vpc"
}

variable "vpc_region_azs" {
  description   = "List of all AZ"
  type          = list(string)
  default       = []
}

variable "vpc_enable_subnet_per_zone" {
  description   = "Enable subnet per zone"
  type          = boolean
  default       = true
}

variable "vpc_public_subnet_number" {
  description   = "number of public subnet"
  type          = number
  default       = 1
}

variable "vpc_private_subnet_number" {
  description   = "number of private subnet"
  type          = number
  default       = 1
}

variable "vpc_enable_nat_gateway" {
  description   = "Whether enable NAT gateway"
  type          = boolean
  default       = true
}

variable "vpc_enable_vpn_gateway" {
  description   = "Whether enable VPN gateway"
  type          = boolean
  default       = false
}
