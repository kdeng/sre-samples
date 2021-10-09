resource "aws_api_gateway_rest_api" "api" {
  name = "lambda-function-api"
}

resource "aws_api_gateway_resource" "api_resource" {
  path_part   = "slack"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration_get" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.method_get.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  #uri                     = aws_lambda_function.lambda.invoke_arn
  uri                     = module.lambda_function.lambda_function_invoke_arn
}

resource "aws_api_gateway_method_response" "get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.method_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_deployment" "my_rest_api_deployment_test" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  #stage_name = aws_api_gateway_stage.gateway_stage_test.stage_name
}

resource "aws_api_gateway_stage" "gateway_stage_test" {
  deployment_id = aws_api_gateway_deployment.my_rest_api_deployment_test.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "test"
}
