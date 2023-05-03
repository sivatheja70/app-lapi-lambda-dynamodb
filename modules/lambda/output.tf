output "get_function_name" {
  value = aws_lambda_function.lambda_for_api[0].function_name
}
output "post_function_name" {
  value = aws_lambda_function.lambda_for_api[1].function_name
}
output "get_function_arn" {
  value = aws_lambda_function.lambda_for_api[0].invoke_arn
}
output "post_function_arn" {
  value = aws_lambda_function.lambda_for_api[1].invoke_arn
}
