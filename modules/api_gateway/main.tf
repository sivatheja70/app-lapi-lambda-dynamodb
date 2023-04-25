# API GATEWAY
resource "aws_api_gateway_rest_api" "api_gw" {
  name        = "${var.api_gateway_environment}-api_gw"
  description = "employeeid API Gateway"
  endpoint_configuration {
    types = ["${var.type}"]
  }
}
/* resource "aws_api_gateway_resource" "pathAccess" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = var.path
} */

resource "aws_api_gateway_method" "accessMethods" {
  for_each    = toset(var.api_gateway_methods)
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  http_method   = each.value
  authorization = "NONE"
}

/* resource "aws_api_gateway_integration" "createproduct-lambda" {
  for_each = toset(var.api_gateway_methods)
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method = each.value
  integration_http_method = "POST"
  type        = var.integration_type
  uri         = var.function_arn[each.key]
} */

resource "aws_api_gateway_integration" "get-lambda-integration" {
  for_each = toset(var.api_gateway_methods)
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method             = "GET"
  integration_http_method = "POST"
  type                    = var.integration_type
  uri                     = var.get_function_arn
}
resource "aws_api_gateway_integration" "post-lambda-integration" {
  for_each = toset(var.api_gateway_methods)
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = var.integration_type
  uri                     = var.post_function_arn
}

resource "aws_api_gateway_method_response" "response_200" {
  for_each        = toset(var.api_gateway_methods)
  rest_api_id     = aws_api_gateway_rest_api.api_gw.id
  resource_id     = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method     = each.value
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  for_each = toset(var.api_gateway_methods)
  depends_on = [
    aws_api_gateway_integration.get-lambda-integration,
    aws_api_gateway_integration.post-lambda-integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method = each.value
  status_code = aws_api_gateway_method_response.response_200[each.key].status_code
  # Transforms the backend JSON response to json. The space is "A must have"
  response_templates = {
    "application/json" = <<EOF
 
 EOF
  }
}

/* resource "aws_lambda_permission" "apigw-CreateProductHandler" {
  action        = "lambda:InvokeFunction"
  function_name = var.function_name[each.key]
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*"
}

resource "aws_api_gateway_deployment" "productapistageprod" {
  depends_on = [
    aws_api_gateway_integration.createproduct-lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = var.stage_name
} */

resource "aws_lambda_permission" "apigw-gettHandler" {
  action        = "lambda:InvokeFunction"
  function_name = var.get_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*"
}

resource "aws_lambda_permission" "apigw-postHandler" {
  action        = "lambda:InvokeFunction"
  function_name = var.post_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*"
}

resource "aws_api_gateway_deployment" "productapistageprod" {
  depends_on = [
    aws_api_gateway_integration.get-lambda-integration,
    aws_api_gateway_integration.post-lambda-integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = var.stage_name
}


