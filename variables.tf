variable "environment" {
}

#DynamoDB
variable "dynamodb_name" {}
variable "billing_mode" {}
variable "read_capacity" {}
variable "write_capacity"{}
variable "hash_key"{}
variable "hash_key_type"{}
/* variable "secondary_key"{}
variable "secondary_key_type"{} */


#lambda
/* variable "function_name" {
  type        = list(string)
} */
variable "run_time"{}
variable "handler"{
  type        = list(string)
}
variable "filename"{
  type        = list(string)
}

# Api Gateway
/* variable "path"{} */
variable "type"{}
variable "api_gateway_methods" {
  type = list(string)
}
variable "integration_type"{}