locals {
  common_tags = {
    Project     = var.project_name
    Terraform   = true
    Environment = var.environment
  }
}

module "stop_ec2_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.22.0"

  source_path   = "${path.module}/lambda-func"
  function_name = "${var.project_name}_stopEC2Lambda"
  lambda_role   = aws_iam_role.stop_start_ec2_role.arn
  create_role   = false
  handler       = "ec2_lambda_handler.stop"
  runtime       = "python3.9"
  publish       = true
  memory_size   = "128"
  timeout       = "60"

  tags = merge(local.common_tags, {

  })

  depends_on = [
    aws_iam_role.stop_start_ec2_role
  ]
}

module "start_ec2_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.22.0"

  source_path   = "${path.module}/lambda-func"
  function_name = "${var.project_name}_startEC2Lambda"
  lambda_role   = aws_iam_role.stop_start_ec2_role.arn
  create_role   = false
  handler       = "ec2_lambda_handler.start"
  runtime       = "python3.9"
  publish       = true
  memory_size   = "128"
  timeout       = "60"

  tags = merge(local.common_tags, {

  })

  depends_on = [
    aws_iam_role.stop_start_ec2_role
  ]
}

