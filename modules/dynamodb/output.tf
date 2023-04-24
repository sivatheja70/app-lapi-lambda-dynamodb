output "dynamodb_created_table" {
  value = aws_dynamodb_table.dynamo_table.*.name
}