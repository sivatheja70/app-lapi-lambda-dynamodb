import json
import boto3

#create a dynamodb object using the AWS SDK
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
#use the DynamoDb object to select our table
table = dynamodb.Table('employeeprofile')

#define the handler function that the lambda will use as an entry pont
def lambda_handler(event, context):
#extract values from the event object we got from the lambda and store in a varable
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