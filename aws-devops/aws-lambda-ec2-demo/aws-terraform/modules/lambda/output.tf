output "start_lambda_func_arn" {
  value = module.start_ec2_lambda.lambda_function_arn
}

output "start_lambda_func_invoke_arn" {
  value = module.start_ec2_lambda.lambda_function_invoke_arn
}

output "stop_lambda_func_arn" {
  value = module.stop_ec2_lambda.lambda_function_arn
}

output "stop_lambda_func_invoke_arn" {
  value = module.stop_ec2_lambda.lambda_function_invoke_arn
}
