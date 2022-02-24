import boto3

# get the dynamodb resource (aka service)
dynamodb = boto3.resource('dynamodb')

# get the table from the dynamodb service
table = dynamodb.Table('message_table')

def print_table_contents():
    items = table.scan()['Items']
    for item in items:
        print(item['subject'])
        print(item['message'])

if __name__=='__main__':
    print_table_contents()