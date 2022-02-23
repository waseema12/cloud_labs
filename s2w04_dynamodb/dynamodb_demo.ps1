# Lambda -> DynamoDB table creation
# Peadar Grant

$TableName="message_table"

# create the table
aws dynamodb create-table --table-name $TableName --attribute-definitions AttributeName=message,AttributeType=S --key-schema AttributeName=message,KeyType=HASH --billing-mode PAY_PER_REQUEST

# checking on table status manually
aws dynamodb describe-table --table-name $TableName

# repeatedly checking, with PowerShell
$TableStatus=""
while ( $True ) {
    $TableStatus = ( aws dynamodb describe-table --table-name $TableName | ConvertFrom-Json ).Table.TableStatus
    Write-Host "Table status: $TableStatus"

    if ( $TableStatus -eq "ACTIVE" ) {
        break
	# looping this way to avoid extraneous Start-Sleep if not necessary
    }

    Start-Sleep -Seconds 10
}

$FunctionName = 'log_message'

# Create deployment package
Compress-Archive -Path log_message.py -DestinationPath log_message_code.zip

# Get Role ARN for LabRole
$Account=(aws sts get-caller-identity | ConvertFrom-Json).Account
$RoleArn="arn:aws:iam::$($Account):role/LabRole"

# Create the function
aws lambda create-function --function-name $FunctionName --runtime python3.8 --handler log_message.log_sns_message_to_dynamodb --role $RoleArn --zip-file fileb://log_message_code.zip

# Get function ARN
$FunctionArn = (aws lambda get-function --function-name $FunctionName | ConvertFrom-Json).Configuration.FunctionArn

# Subscribe
aws sns subscribe --topic-arn $TopicArn --protocol lambda --notification-endpoint $FunctionArn

# Add permissions
aws lambda add-permission --function-name $FunctionName --source-arn $TopicArn --action "lambda:InvokeFunction"  --principal sns.amazonaws.com  --statement-id grant-topic-access-to-function

# Send test message
aws sns publish --topic-arn $TopicArn --subject "Test subject" --message "Test message"

# Scan (i.e. select *) from the table
aws dynamodb scan --table-name $TableName

# delete table
# aws dynamodb delete-table --table-name $TableName
