import json
import boto3
import sys

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('message_table')

def log_message_to_dynamodb(subject, message):
    response = table.put_item(
        Item={
            'subject': subject,
            'message': message
            }
        )
    return response

def log_sns_message_to_dynamodb(event, context):    
    # pull out subject & message
    subject = event['Records'][0]['Sns']['Subject']
    message = event['Records'][0]['Sns']['Message']

    # log to dynamodb
    log_message_to_dynamodb(subject, message)
    
if __name__=='__main__':
    log_message_to_dynamodb(sys.argv[0], sys.argv[1])
