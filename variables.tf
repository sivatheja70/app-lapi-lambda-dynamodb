variable "environment" {}

#cloudfront
variable "origin_id" {}
variable "default_root_object" {}
variable "existing_bucket" {}

#DynamoDB
variable "dynamodb_name" {}
variable "billing_mode" {}
variable "read_capacity" {}
variable "write_capacity" {}
variable "hash_key" {}
variable "hash_key_type" {}

#lambda
variable "run_time" {}
variable "handler" {
  type = list(string)
}
variable "filename" {
  type = list(string)
}
variable "dr" {}

# Api Gateway
variable "type" {}
variable "api_gateway_methods" {
  type = list(string)
}
variable "integration_type" {}
