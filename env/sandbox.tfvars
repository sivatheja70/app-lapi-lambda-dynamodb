environment = "sandbox"

#DynamoDB
billing_mode = "PAY_PER_REQUEST"
read_capacity = 5 
write_capacity  = 5 
hash_key = "id"
hash_key_type = "S"
secondary_key = "name"
secondary_key_type = "S"
#Lambda
run_time="python3.8"
handler="crudLambdaHandler.lambda_handler"
filename="crudLambdaHandler.py"
#API GATEWAY
type="REGIONAL"
path="example"
api_gateway_methods=["GET", "POST"]
integration_type = "AWS_PROXY"