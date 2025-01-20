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

output "vpc_public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}
output "vpc_public_subnets_cidr" {
  description = "List of public subnet CIDRs"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "region" {
  description = "AWS region"
  value       = var.project_region
}

output "azs" {
  description = "VPC AZs"
  value       = data.aws_availability_zones.available.names
}

# output "api_gateway_deployment_test_invoke_url" {
#   value = aws_api_gateway_deployment.my_rest_api_test.invoke_url
# }

# output "api_gateway_deployment_prod_invoke_url" {
#   value = aws_api_gateway_deployment.my_rest_api_prod.invoke_url
# }

output "api_gateway_test_satge_invoke_url" {
  value = aws_api_gateway_stage.gateway_stage_test.invoke_url
}


# output "api_gateway_prod_satge_invoke_url" {
#   value = aws_api_gateway_stage.gateway_stage_prod.invoke_url
# }


# output "api_gateway_deployment_execution_arn" {
#   value = aws_api_gateway_deployment.my_rest_api_test.execution_arn
# }

# output "api_gateway_satge_invoke_url" {
#   value = aws_api_gateway_stage.my_gateway_stage.invoke_url
# }

# output "api_gateway_stage_execution_arn" {
#   value = aws_api_gateway_stage.my_gateway_stage.execution_arn
# }