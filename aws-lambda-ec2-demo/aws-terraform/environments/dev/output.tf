output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "vpc_private_subnets_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.vpc_private_subnets_ids
}

output "vpc_private_subnets_cidr" {
  description = "List of private subnet CIDRs"
  value       = module.vpc.vpc_private_subnets_cidr
}

output "vpc_private_subnets_zone" {
  description = "List of private subnet zone"
  value       = module.vpc.vpc_private_subnets_zone
}

output "vpc_public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.vpc_public_subnet_ids
}

output "vpc_public_subnets_cidr" {
  description = "List of public subnet CIDRs"
  value       = module.vpc.vpc_public_subnets_cidr
}

output "vpc_public_subnets_zone" {
  description = "List of public subnet zone"
  value       = module.vpc.vpc_public_subnets_zone
}


output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "instance_private_ip" {
  value = module.ec2_instance.instance_private_ip
}

output "instance_private_dns" {
  value = module.ec2_instance.instance_private_dns
}

output "instance_secruity_groups" {
  value = module.ec2_instance.instance_secruity_groups
}


output "start_lambda_func_arn" {
  value = module.lambda_funcs.start_lambda_func_arn
}

output "start_lambda_func_invoke_arn" {
  value = module.lambda_funcs.start_lambda_func_invoke_arn
}

output "stop_lambda_func_arn" {
  value = module.lambda_funcs.stop_lambda_func_arn
}

output "stop_lambda_func_invoke_arn" {
  value = module.lambda_funcs.stop_lambda_func_invoke_arn
}
