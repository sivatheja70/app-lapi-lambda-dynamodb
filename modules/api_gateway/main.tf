# API GATEWAY
resource "aws_api_gateway_rest_api" "api_gw" {
  name        = "${var.api_gateway_environment}-api_gw"
  description = "Test API Gateway"
  endpoint_configuration {
    types = ["${var.type}"]
  }
}
resource "aws_api_gateway_resource" "pathAccess" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = var.path
}
resource "aws_api_gateway_method" "accessMethods" {
  for_each = toset(var.api_gateway_methods)
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_resource.pathAccess.id
  http_method   = each.value
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "createproduct-lambda" {
  for_each = toset(var.api_gateway_methods)
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method = each.value
  integration_http_method = "POST"
  type                    = var.integration_type
  uri = var.function_arn
}

resource "aws_lambda_permission" "apigw-CreateProductHandler" {
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*"
}
resource "aws_api_gateway_deployment" "productapistageprod" {
  depends_on = [
    aws_api_gateway_integration.createproduct-lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = var.stage_name
}


