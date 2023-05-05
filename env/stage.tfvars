environment = "stage"

#cloudfront
origin_id           = "s3_origin"
default_root_object = "index.html"
existing_bucket     = "sivatheja-test-cf"

#DynamoDB
dynamodb_name  = "employeeprofile"
billing_mode   = "PAY_PER_REQUEST"
read_capacity  = "5"
write_capacity = "5"
hash_key       = "empId"
hash_key_type  = "S"

#Lambda
run_time = "python3.9"
handler  = ["getlambda.lambda_handler", "insertlambda.lambda_handler"]
filename = ["getlambda.py", "insertlambda.py"]
dr       = "false"

#API GATEWAY
type                = "EDGE"
api_gateway_methods = ["GET", "POST"]
integration_type    = "AWS"