module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-in-vpc"
  description   = "My awesome lambda function"
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  source_path = "../lambda-func"
  
  create_current_version_allowed_triggers = false
  
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  attach_network_policy = true

  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = aws_api_gateway_stage.gateway_stage_test.execution_arn
    },
    # APIGatewayAny = {
    #   service    = "apigateway"
    #   source_arn = aws_api_gateway_stage.gateway_stage_prod.execution_arn
    # },
    # APIGatewayDevPost = {
    #   service    = "apigateway"
    #   source_arn = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0/dev/POST/*"
    # },
    # OneRule = {
    #   principal  = "events.amazonaws.com"
    #   source_arn = "arn:aws:events:eu-west-1:135367859851:rule/RunDaily"
    # }
  }
}
