variable "api_gateway_environment" {}
variable "get_function_name" {}
variable "post_function_name" {}
variable "get_function_arn" {}
variable "post_function_arn" {}
variable "stage_name" {}
variable "type" {}
variable "api_gateway_methods" {
  type = list(string)
}
variable "integration_type" {}
