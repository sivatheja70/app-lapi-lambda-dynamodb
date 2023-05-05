import os
import json
import boto3

def lambda_handler(event, context):
    region = os.environ['REGION']
    dynamodb = boto3.resource('dynamodb', region_name=region)

    #use the DynamoDB object to select our table
    table = dynamodb.Table('employeeprofile')

    #extract values from the event object we got from the lambda and store in a variable
    firstname = event['empFirstName']
    id = event['empId']
    lastname = event['empLastName']
    age = event['empAge']

    #write name and time to the dynamodb table using the object we initiated and save response in a variable
    response = table.put_item(
        Item = {
            'empId' : id,
            'empAge' : age,
            'empFirstName' : firstname,
            'empLastName' : lastname
        })

    #return
    return {
        'statusCode': 200,
        'body': json.dumps('data added!' + firstname)
    }