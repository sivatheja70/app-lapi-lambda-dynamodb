resource "aws_dynamodb_table" "dynamo_table" {
  name         = var.dynamodb_name
  billing_mode = var.billing_mode
  write_capacity  = var.billing_mode =="PROVISIONED" ? var.write_capacity : null
  read_capacity = var.billing_mode=="PROVISIONED"  ? var.read_capacity : null

  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }
  /* attribute {
    name = var.secondary_key
    type = var.secondary_key_type
  }
   global_secondary_index {
      name               = var.secondary_key
      hash_key           = var.secondary_key
      projection_type    = "ALL"
    } */
}

provider "aws" {
  alias  = "region2"
  region = "us-west-2"
}

resource "aws_dynamodb_table_replica" "dynamo_table_replica" {
  provider         = aws.region2
  global_table_arn = aws_dynamodb_table.dynamo_table.arn

  tags = {
    Name = "employeeprofile"
  }
}

