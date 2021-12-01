variable "project_name" {
  description   = "The name of current infrastructure"
  type          = string
  default       = "kefeng"
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

variable "environment" {
  description   = "Environment of this cluster"
  type          = string
  default       = "dev"
}

variable "vpc_enable_subnet_per_zone" {
  description   = "Whether create subnet per zone"
  default       = false
}

variable "vpc_public_subnet_length" {
  description   = "Public subnet length in region"
  default       = 2
}

variable "vpc_private_subnet_length" {
  description   = "Private subnet length in region"
  default       = 2
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


variable "instance_type" {
  default       = "t3.micro"
}


variable "instance_key_name" {
  default       = "instance_key"
}
