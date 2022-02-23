cd Desktop/cloud_labs
git pull
./learner_lab.ps1
./paste_credentials.ps1
./lab_checks.ps1
cd s2w04_dynamodb
ls
./dynamodb_lab_setup.ps1
aws sns publish --topic-arn $TopicArn --message xyz
$TableName="message_table"
aws dynamodb create-table 
aws dynamodb create-table --table-name $TableName --attribute-definitions AttributeName=message,AttributeType=S --key-schema AttributeName=message,KeyType=HASH --billing-mode PAY_PER_REQUEST
aws dynamodb describe-table --table-name $TableName
Compress-Archive -Path log_message.py -DestinationPath log_message_code.zip
$Account=(aws sts get-caller-identity | ConvertFrom-Json).Account
$RoleArn="arn:aws:iam::$($Account):role/LabRole"
$RoleArn
xaws lambda create-function --function-name $FunctionName 
$FunctionName="log_message"
xaws lambda create-function --function-name $FunctionName 
aws lambda create-function --function-name $FunctionName 
aws lambda create-function --function-name $FunctionName --runtime python3.8 --role $RoleArn --handler log_message.log_sns_message_to_dynamodb --zip-file fileb://log_message_code.zip
aws lambda add-permission --function-name $FunctionName --source-arn $TopicArn --action "lambda:InvokeFunction" --principal sns.amazonaws.com --statement-id grant-topic-access-to-function
aws sns subscribe --protocol lambda --topic-arn $TopicArn --notification-endpoint $FunctionArn 
aws lambda get-function --function-name $FunctionName 
$FunctionArn = (aws lambda get-function --function-name $FunctionName | ConvertFrom-Json).Configuration.FunctionArn
aws sns subscribe --protocol lambda --topic-arn $TopicArn --notification-endpoint $FunctionArn 
aws sns publish --topic-arn $TopicArn --subject "Test subject" --message "Test message"
aws dynamodb scan --table-name $TableName
aws sns publish --topic-arn $TopicArn --subject "Test subject" --message "Test message"
aws dynamodb scan --table-name $TableName
aws sns publish --topic-arn $TopicArn --subject "Test subject 2" --message "Test message 2"
aws dynamodb scan --table-name $TableName
