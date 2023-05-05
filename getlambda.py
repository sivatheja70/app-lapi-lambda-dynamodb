import os
import json
import boto3

def lambda_handler(event, context):
    region = os.environ['REGION']
    dynamodb = boto3.resource('dynamodb', region_name=region)

    table = dynamodb.Table('employeeprofile')
    
    # Check if there are any query parameters in the event
    if event.get('queryStringParameters'):
        # Get the query parameters from the event
        query_params = event['queryStringParameters']
        # Use the query parameters to filter the items in the scan operation
        response = table.scan(
            FilterExpression=Attr(query_params['filter_key']).eq(query_params['filter_value'])
        )
    else:
        # If there are no query parameters, retrieve all the items from the table
        response = table.scan()
    
    data = response['Items']
    
    while 'LastEvaluateKey' in response:
        response = table.scan(ExclusiveStartKey=response['LastEvaluateKey'])
        data.extend(response['Items'])
    
    # Return the list of items as a JSON response
    return {
        'statusCode': 200,
        'body': json.dumps(data)
    }