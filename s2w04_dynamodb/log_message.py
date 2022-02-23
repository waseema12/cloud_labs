import json
import boto3
import sys

# get the dynamodb resource (aka service)
dynamodb = boto3.resource('dynamodb')

# get the table from the dynamodb service
table = dynamodb.Table('message_table')

def log_message_to_dynamodb(subject, message):
    response = table.put_item(
        Item={
            'subject': subject,
            'message': message
            }
        )
        # Item argument should be a Python dictionary!
    return response

def log_sns_message_to_dynamodb(event, context):    
    # pull out subject & message
    subject = event['Records'][0]['Sns']['Subject']
    message = event['Records'][0]['Sns']['Message']

    # log to dynamodb
    log_message_to_dynamodb(subject, message)
    
# running from local machine (just does DynamoDB insert)
if __name__=='__main__':
    if len(sys.argv)<3:
        sys.exit("usage: python3 ./log_message.py [subject] [message]")
    log_message_to_dynamodb(sys.argv[1], sys.argv[2])
