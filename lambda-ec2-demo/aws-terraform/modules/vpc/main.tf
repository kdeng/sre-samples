locals {
  common_tags = {
    Project     = var.project_name
    Terraform   = true
  }

  public_subnet_length    = length(var.vpc_public_subnet_zone)
  private_subnet_length   = length(var.vpc_private_subnet_zone)

  vpc_public_subnets            = [for i in range(local.public_subnet_length) : cidrsubnet(var.project_cidr, 8, i + 1)]
  vpc_private_subnets           = [for i in range(local.private_subnet_length) : cidrsubnet(var.project_cidr, 8, i + 101)]
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name = "${var.project_name}-vpc"
  cidr = var.project_cidr
  azs  = distinct(concat(var.vpc_public_subnet_zone, var.vpc_private_subnet_zone))
  tags = merge(local.common_tags, {
  })

  # public subnet
  public_subnets = local.vpc_public_subnets
  public_subnet_suffix  = "public-subnet"
  public_subnet_tags = merge(local.common_tags, {
    "SubnetType"                                = "public-subnet"
  })
  public_route_table_tags = merge(local.common_tags, {
    RouteTableType  = "public-route"
  })
  propagate_public_route_tables_vgw = true

  # private subnet
  private_subnets  = local.vpc_private_subnets
  private_subnet_suffix = "private-subnet"
  private_subnet_tags = merge(local.common_tags, {
    "SubnetType"                                = "private-subnet"
  })
  private_route_table_tags = merge(local.common_tags, {
    RouteTableType  = "private-route"
  })
  propagate_private_route_tables_vgw = true

  enable_dns_hostnames    = var.vpc_enable_dns_hostnames
  enable_dns_support      = var.vpc_enable_dns_support
  enable_vpn_gateway      = var.vpc_enable_vpn_gateway
  enable_nat_gateway      = var.vpc_enable_nat_gateway
  single_nat_gateway      = var.vpc_single_nat_gateway
  one_nat_gateway_per_az  = var.vpc_one_nat_gateway_per_az
}
