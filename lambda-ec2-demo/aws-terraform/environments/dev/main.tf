terraform {
  # backend "s3" {
  #   bucket = "changeme"
  #   key    = "my-eks-cluster/terraform.tfstate"
  #   region = "us-east-2"
  # }
}

provider "aws" {
  region = var.project_region
}

locals {
  max_subnet_length       = length(data.aws_availability_zones.available.names)
  public_subnet_length    = var.vpc_enable_subnet_per_zone ? local.max_subnet_length : var.vpc_public_subnet_length > local.max_subnet_length ? local.max_subnet_length : var.vpc_public_subnet_length
  private_subnet_length   = var.vpc_enable_subnet_per_zone ? local.max_subnet_length : var.vpc_private_subnet_length > local.max_subnet_length ? local.max_subnet_length : var.vpc_private_subnet_length
  
  public_subnet_zone      = var.vpc_enable_subnet_per_zone ? data.aws_availability_zones.available.names : slice(data.aws_availability_zones.available.names, 0, local.public_subnet_length)
  private_subnet_zone      = var.vpc_enable_subnet_per_zone ? data.aws_availability_zones.available.names : slice(data.aws_availability_zones.available.names, 0, local.private_subnet_length)
}

module "vpc" {
  source = "../../modules/vpc"
  project_name        = var.project_name
  project_region      = var.project_region
  project_cidr        = var.project_cidr

  vpc_public_subnet_zone      = local.public_subnet_zone
  vpc_private_subnet_zone     = local.private_subnet_zone
  vpc_enable_dns_hostnames    = var.vpc_enable_dns_hostnames
  vpc_enable_dns_support      = var.vpc_enable_dns_support
  vpc_enable_vpn_gateway      = var.vpc_enable_vpn_gateway
  vpc_enable_nat_gateway      = var.vpc_enable_nat_gateway
  vpc_single_nat_gateway      = var.vpc_single_nat_gateway
  vpc_one_nat_gateway_per_az  = var.vpc_one_nat_gateway_per_az
}


module "ec2_instance" {
  source = "../../modules/ec2-instance"
  project_name        = var.project_name
  project_region      = var.project_region
  project_cidr        = var.project_cidr
  environment         = var.environment

  instance_type       = var.instance_type
  instance_key_name   = var.instance_key_name
  instance_subnet     = module.vpc.vpc_private_subnets_ids[0]

  depends_on = [
    module.vpc
  ]
}


module "lambda_funcs" {
  source = "../../modules/lambda"
  project_name        = var.project_name
  environment         = var.environment

  depends_on = [
    module.vpc,
    module.ec2_instance
  ]
}
