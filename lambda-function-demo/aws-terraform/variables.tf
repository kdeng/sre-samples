variable "project_name" {
  description   = "The name of current infrastructure"
  type          = string
  default       = "recruitable-QA"
}

variable "project_region" {
  description   = "The default region to setup jenkins cluster"
  type          = string
  default       = "ap-southeast-2"
}

variable "project_cidr" {
  description   = "The default region to setup jenkins cluster"
  type          = string
  default       = "10.0.0.0/16"
}

# variable "cluster_name" {
#   description   = "The cluster name of jenkins cluster"
#   type          = string
#   default       = "recruitable-eks-cluster-QA"
# }

variable "environment" {
  description   = "Environment of this cluster"
  type          = string
  default       = "QA"
}

variable "vpc_enable_dns_hostnames" {
  description   = "Enable DNS hostname"
  type          = bool
  default       = true
}

variable "vpc_enable_dns_support" {
  description   = "Enable DNS support"
  type          = bool
  default       = true
}

variable "vpc_enable_vpn_gateway" {
  description   = "Enable VPN gateway"
  type          = bool
  default       = false
}

variable "vpc_enable_nat_gateway" {
  description   = "Enable NAT gateway"
  type          = bool
  default       = true
}

variable "vpc_single_nat_gateway" {
  description   = "Enable single NAT gateway"
  type          = bool
  default       = false
}

variable "vpc_one_nat_gateway_per_az" {
  description   = "Enable one NAT gateway per AZ"
  type          = bool
  default       = true
}
