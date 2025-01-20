output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "vpc_private_subnets_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "vpc_private_subnets_cidr" {
  description = "List of private subnet CIDRs"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "vpc_private_subnets_zone" {
  description = "List of private subnet zone"
  value       = var.vpc_private_subnet_zone
}

output "vpc_public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "vpc_public_subnets_cidr" {
  description = "List of public subnet CIDRs"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "vpc_public_subnets_zone" {
  description = "List of public subnet zone"
  value       = var.vpc_public_subnet_zone
}

