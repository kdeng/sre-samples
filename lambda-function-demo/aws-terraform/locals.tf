locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = true
  }

  subnet_length       = length(data.aws_availability_zones.available.names)
  vpc_public_subnets  = [for i in range(local.subnet_length) : cidrsubnet(var.project_cidr, 8, i + 1)]
  vpc_private_subnets = [for i in range(local.subnet_length) : cidrsubnet(var.project_cidr, 8, i + 101)]
}
