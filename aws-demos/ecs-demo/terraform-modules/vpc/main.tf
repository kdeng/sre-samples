locals {
    # VPC
  max_subnet_length       = length(data.aws_availability_zones.available.names)
  public_subnet_length    = var.vpc_enable_subnet_per_zone ? local.max_subnet_length : min(local.max_subnet_length, var.vpc_public_subnet_number)
  private_subnet_length   = var.vpc_enable_subnet_per_zone ? local.max_subnet_length : min(local.max_subnet_length, var.vpc_private_subnet_number)

  vpc_public_subnets  = [for i in range(local.public_subnet_length) : cidrsubnet(var.project_cidr, 8, i + 1)]
  vpc_private_subnets = [for i in range(local.private_subnet_length) : cidrsubnet(var.project_cidr, 8, i + 101)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = var.vpc_name
  cidr = var.project_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
  enable_vpn_gateway = var.vpc_enable_vpn_gateway

  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}
