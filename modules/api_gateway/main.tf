# API GATEWAY
resource "aws_api_gateway_rest_api" "api_gw" {
  name        = "${var.api_gateway_environment}-api_gw"
  description = "employeeid API Gateway"
  endpoint_configuration {
    types = [var.type]
  }
}

resource "aws_api_gateway_method" "accessMethods" {
  for_each    = toset(var.api_gateway_methods)
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  http_method   = each.value
  authorization = "NONE"
  }
####################################################################
resource "aws_api_gateway_method" "optionsmethod" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
#####################################################################
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
########################################################################
resource "aws_api_gateway_integration" "optionsintegration" {
    rest_api_id   = aws_api_gateway_rest_api.api_gw.id
    resource_id   = aws_api_gateway_method.optionsmethod.resource_id
    http_method   = aws_api_gateway_method.optionsmethod.http_method
    type          = "MOCK"
    request_templates = {
      "application/json" = "{\"statusCode\": 200}"
    }
}

#######################################################################

resource "aws_api_gateway_integration_response" "optionsintegrationresponse" {
    rest_api_id   = aws_api_gateway_rest_api.api_gw.id
    resource_id   = aws_api_gateway_method.optionsmethod.resource_id
    http_method   = aws_api_gateway_method.optionsmethod.http_method
    status_code   = "200"
    response_templates = {
      "application/json" = "{ }"
    }
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
      "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
      "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }
    depends_on = [
      aws_api_gateway_method.optionsmethod,
      aws_api_gateway_integration.optionsintegration
    ]
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  for_each = toset(var.api_gateway_methods)
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method = each.value
  status_code = aws_api_gateway_method_response.response_200[each.key].status_code
  response_parameters = {
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = [
      aws_api_gateway_method.accessMethods,
      aws_api_gateway_integration.get-lambda-integration,
      aws_api_gateway_integration.post-lambda-integration
    ]
}

resource "aws_api_gateway_method_response" "response_200" {
  for_each        = toset(var.api_gateway_methods)
  rest_api_id     = aws_api_gateway_rest_api.api_gw.id
  resource_id     = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method     = each.value
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
        "method.response.header.Access-Control-Allow-Origin" = true
    }
  depends_on = [
    aws_api_gateway_integration.get-lambda-integration,
    aws_api_gateway_integration.post-lambda-integration,
    aws_api_gateway_integration.optionsintegration,
    aws_api_gateway_integration_response.optionsintegrationresponse,
  ]

}

resource "aws_api_gateway_method_response" "options200" {
    rest_api_id   = aws_api_gateway_rest_api.api_gw.id
    resource_id   = aws_api_gateway_method.optionsmethod.resource_id
    http_method   = aws_api_gateway_method.optionsmethod.http_method
    status_code   = "200"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true
        "method.response.header.Access-Control-Allow-Methods" = true
        "method.response.header.Access-Control-Allow-Origin" = true
    }
    response_models = {
        "application/json" = "Empty"
    }
}

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
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name        = var.stage_name

  variables = {
    trigger_hash = sha1(join(",", [
      jsonencode(aws_api_gateway_method.accessMethods),
      jsonencode(aws_api_gateway_method.optionsmethod),
      jsonencode(aws_api_gateway_integration.get-lambda-integration),
      jsonencode(aws_api_gateway_integration.post-lambda-integration),
      jsonencode(aws_api_gateway_integration.optionsintegration),
      jsonencode(aws_api_gateway_integration_response.optionsintegrationresponse),
      jsonencode(aws_api_gateway_integration_response.IntegrationResponse),
      jsonencode(aws_api_gateway_method_response.response_200),
      jsonencode(aws_api_gateway_method_response.options200),
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
