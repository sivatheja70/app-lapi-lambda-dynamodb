
# lambda function starts here

resource "aws_iam_role" "lambda_for_api_role" {
  name = "${var.environment}-lambda_for_api_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.lambda_for_api_role.name
}


resource "aws_iam_role_policy_attachment" "lambda_for_api_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_for_api_role.name
}

resource "aws_lambda_function" "lambda_for_api" {
  count = length(var.function_name)
  function_name = var.function_name[count.index]
  role = aws_iam_role.lambda_for_api_role.arn
  handler       = var.handler[count.index]
  runtime       = var.run_time
  filename      = var.file_path[count.index]

  /* environment {
    variables = {
      TABLE_NAME = var.dynamodb_created_table
    }
  } */
}



