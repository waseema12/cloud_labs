cd ~/Desktop/cloud_labs
ls
cd s2w04*
ls
./dynamodb_lab_setup.ps1
$TableName="message_table"
aws dynamodb create-table --table-name $TableName --attribute-definitions AttributeName=message,AttributeType=S --key-schema AttributeName=message,KeyType=HASH --billing-mode PAY_PER_REQUEST
aws dynamodb delete-table --table-name $TableName
aws dynamodb create-table --table-name $TableName --attribute-definitions AttributeName=message,AttributeType=S --key-schema AttributeName=message,KeyType=HASH --billing-mode PAY_PER_REQUEST
$FunctionName='log_message'
ls
Compress-Archive -Path log_message.py -DestinationPath log_message_code.zip -Force
$Account=(aws sts get-caller-identity |ConvertFrom-Json).Account
$Account
$RoleArn="arn:aws:iam::$($Account):role/LabRole"
aws lambda create-function --function-name $FunctionName --runtime python3.8 --handler log_message.log_sns_message_to_dynamodb --role $RoleArn 
aws lambda create-function --function-name $FunctionName --runtime python3.8 --handler log_message.log_sns_message_to_dynamodb --role $RoleArn --zip-file fileb://log_message_code.zip
aws lambda get-function
aws lambda get-function --function-name $FunctionName
$FunctionArn = (aws lambda get-function --function-name $FunctionName | ConvertFrom-Json).Configuration.FunctionARn
$FunctionArn = (aws lambda get-function --function-name $FunctionName | ConvertFrom-Json).Configuration.FunctionArn
$FunctionArn
aws sns subscribe --topic-arn $TopicArn --protocol lambda --notification-endpoint $FunctionArn
aws lambda add-permission --function-name $FunctionName --source-arn $TopicArn --action "lambda:InvokeFunction" --principal sns.amazonaws.com --statement-id grant-topic-access-to-function
aws sns publish --topic $TopicArn --message "12345" --subject "wxyz"
ls
aws dynamodb scan --table-name $TableName
aws dynamodb scan --table-name $TableName
javac
java
aws dynamodb scan 
aws dynamodb scan --table-name $TableName
aws sns publish --topic $TopicArn --message "1234555555555" --subject "wxyz"
aws sns publish --topic $TopicArn --message "1234555555555xgfdg" --subject "wxyz"
aws dynamodb scan 
aws dynamodb scan --table-name $TableName
ls
./show_table.ps1
./show_table.ps1
python3 show_table.py
aws dyanamodb scan --table-name message_table
python3 show_table.py
aws dynamodb scan --table-name message_table
aws dynamodb scan --table-name message_table
python3 show_table.py
python3 show_table.py
python3 show_table.py
python3 show_table.py
python3 show_table.py
python3 show_table.py
python3 show_table.py
python3 show_table.py
python3 show_table.py
python3 show_table.py
