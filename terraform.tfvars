environment = "sandbox"
#DynamoDB
dynamodb_name = "employeeprofile"
billing_mode = "PAY_PER_REQUEST"
read_capacity = "5" 
write_capacity  = "5" 
hash_key = "empId"
hash_key_type = "S"
/* secondary_key = "name"
secondary_key_type = "S" */

#Lambda
/* function_name =["${var.environment}-get-lambda", "${var.environment}-get-lambda"] */
run_time="python3.9"
handler=["getlambda.lambda_handler", "insertlambda.lambda_handler"]
filename=["getlambda.py", "insertlambda.py"]

#API GATEWAY
type="REGIONAL"
path="example"
api_gateway_methods=["ANY"]
integration_type = "AWS_PROXY"