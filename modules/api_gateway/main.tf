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

  /* request_parameters = {
    "method.request.header.Content-Type" = true
  }

  request_models = {
    "application/json" = "Empty"
  }
  ##new added
  integration {
    type                    = var.integration_type
    http_method             = "POST"
    uri                     = var.get_function_arn
    integration_http_method = "POST"
    request_templates = {
      "application/json" = "{ }"
    } */

    /* response_parameters = {
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
    } */
  }
####################################################################
resource "aws_api_gateway_method" "optionsmethod" {
  /* for_each    = toset(var.api_gateway_methods) */
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  http_method   = "OPTIONS"
  /* http_method   = "POST" */
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
  /* integration_responses {
    status_code = "200"
    response_templates = {
      "application/json" = "{ }"
    } */
}
resource "aws_api_gateway_integration" "post-lambda-integration" {
  for_each = toset(var.api_gateway_methods)
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = var.integration_type
  uri                     = var.post_function_arn
  /* integration_responses {
    status_code = "200"
    response_templates = {
      "application/json" = "{ }"
    } */
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
        /* "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Requested-With'" */
        /* "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'" */
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = [
      aws_api_gateway_method.accessMethods,
      aws_api_gateway_integration.get-lambda-integration,
      aws_api_gateway_integration.post-lambda-integration
    ]
  # Transforms the backend JSON response to json. The space is "A must have"
  /* response_templates = {
    "application/json" = <<EOF
 
 EOF
  } */
}

resource "aws_api_gateway_method_response" "response_200" {
  for_each        = toset(var.api_gateway_methods)
  rest_api_id     = aws_api_gateway_rest_api.api_gw.id
  resource_id     = aws_api_gateway_method.accessMethods[each.key].resource_id
  http_method     = each.value
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
        /* "method.response.header.Access-Control-Allow-Headers" = true
        "method.response.header.Access-Control-Allow-Methods" = true */
        "method.response.header.Access-Control-Allow-Origin" = true
    }
   /* response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  } */
  /* response_models = {
    "application/json" = "Empty"
  } */

  depends_on = [
    aws_api_gateway_integration.get-lambda-integration,
    aws_api_gateway_integration.post-lambda-integration,
    aws_api_gateway_integration.optionsintegration,
    aws_api_gateway_integration_response.optionsintegrationresponse,
    /* aws_api_gateway_integration_response.IntegrationResponse */
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
    /* response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
      "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'"
      "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    } */
    response_models = {
        "application/json" = "Empty"
    }
    /* depends_on = [
      aws_api_gateway_integration.get-lambda-integration,
      aws_api_gateway_integration.post-lambda-integration,
      aws_api_gateway_integration.optionsintegration,
      aws_api_gateway_integration_response.optionsintegrationresponse,
    ] */
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

/* resource "aws_api_gateway_deployment" "productapistageprod" {
  depends_on = [
    aws_api_gateway_method_response.response_200,
    aws_api_gateway_method_response.response_200, */
    /* aws_api_gateway_integration.optionsintegration */
  /* ]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = var.stage_name
} */

#####################redeployment#######################################################
/* resource "aws_api_gateway_deployment" "productapistageprod" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id

  triggers = {
    redeployment = sha1(jsonencode([
      values(aws_api_gateway_method.accessMethods)[*].id,
      aws_api_gateway_method.optionsmethod.id,
      values(aws_api_gateway_integration.get-lambda-integration)[*].id,
      values(aws_api_gateway_integration.post-lambda-integration)[*].id,
      aws_api_gateway_integration.optionsintegration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.productapistageprod.id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  stage_name    = var.stage_name
} */

###############$$$$$$$$$####################################################
/* resource "aws_api_gateway_deployment" "productapistageprod" {
  depends_on = [
    "aws_api_gateway_method.accessMethods",
    "aws_api_gateway_integration.get-lambda-integration",
    "aws_api_gateway_integration.post-lambda-integration",
    "aws_api_gateway_integration.optionsintegration",
  ]

  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_description = "${md5(file("${path.module}/main.tf"))}"
  stage_name        = var.stage_name

  lifecycle {
    create_before_destroy = true
  }
} */

resource "aws_api_gateway_deployment" "productapistageprod" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name        = var.stage_name

  variables = {
    // For new changes to the API to be correctly deployed, they need to
    // be detected by terraform as a trigger to recreate the aws_api_gateway_deployment.
    // This is because AWS keeps a "working copy" of the API resources which does not
    // go live until a new aws_api_gateway_deployment is created.
    // Here we use a dummy stage variable to force a new aws_api_gateway_deployment.
    // We want it to detect if any of the API-defining resources have changed so we
    // hash all of their configurations.
    // IMPORTANT: This list must include all API resources that define the "content" of
    // the rest API. That means anything except for aws_api_gateway_rest_api,
    // aws_api_gateway_stage, aws_api_gateway_base_path_mapping, that are higher-level
    // resources. Any change to a part of the API not included in this list might not
    // trigger creation of a new aws_api_gateway_deployment and thus not fully deployed.
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
