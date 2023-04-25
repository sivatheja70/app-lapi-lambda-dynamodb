provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-west-2"
}

terraform {
  backend "s3" {
  }
}

data "archive_file" "handler_zip" {
  count       = length(var.filename)
  type        = "zip"
  source_file = "${path.module}/${var.filename[count.index]}"
  output_path = "${path.module}/handler${count.index + 1}.zip"
}

#Dynamo DB
module "dynamodb" {
  source         = "./modules/dynamodb"
  dynamodb_name  = var.dynamodb_name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  hash_key_type  = var.hash_key_type
  /* secondary_key = var.secondary_key
  secondary_key_type = var.secondary_key_type
  dynamodb_environment = var.environment */
}

#Lambda
module "lambda" {
  source        = "./modules/lambda"
  function_name = ["${var.environment}-get-lambda", "${var.environment}-insert-lambda"]
  handler       = var.handler
  run_time      = var.run_time
  file_path     = [for zip_file in data.archive_file.handler_zip : zip_file.output_path]
  environment   = var.environment
  /* dynamodb_created_table = module.dynamodb.dynamodb_created_table */
}
#Api Gateway
module "api_gateway" {
  source           = "./modules/api_gateway"
  integration_type = var.integration_type
  /* path = var.path */
  type                = var.type
  api_gateway_methods = var.api_gateway_methods
  stage_name          = var.environment
  /* function_name = module.lambda.created_lambda_function_name */
  get_function_name  = module.lambda.get_function_name
  post_function_name = module.lambda.post_function_name
  /* function_arn = module.lambda.created_lambda_function_arn */
  get_function_arn        = module.lambda.get_function_arn
  post_function_arn       = module.lambda.post_function_arn
  api_gateway_environment = var.environment
}



