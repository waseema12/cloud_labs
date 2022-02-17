../save_history.ps1 
git status
git rm -f Write-Host "output to $OutFilename"
git rm -f _capture/history_2022-02-17-1416.ps1
git status
./lambda_lab_setup.ps1
aws sns unsubscribe --subscription-arn "arn:aws:sns:us-east-1:381303118602:lambdatopic:c5c15fd8-00a3-41a5-9d49-43d3e40c55f9"
./lambda_lab_setup.ps1
aws sns publish --topic-arn $TOpicArn --message wcyz --subject j9r4903
Compress-Archive -Path display_event.py -DestinationPath display_event.zip
$Account=(aws sts get-caller-identity | ConvertFrom-Json).Account
$RoleArn="arn:aws:iam::$($Account):role/LabRole"
aws lambda create-function --function-name display_event --handler display_event.display_event --runtime python3.8 --role $RoleArn --zip-file display_event.zip
aws lambda create-function --function-name display_event --handler display_event.display_event --runtime python3.8 --role $RoleArn --zip-file fileb://display_event.zip
aws lambda update-function-code --function-name display_event --zip-file fileb://display_event.zip
aws lambda get-function --function-name display_event
$FunctionArn = (aws lambda get-function --function-name display_event | ConvertFrom-Json).Configuration.FunctionArn 
$FunctionArn
aws sns subscribe help 
aws sns subscribe --topic-arn $TopicArn --protocol lambda --notification-endpoint $FunctionArn
aws sns publish --topic-arn $TOpicArn --message "Message to function" --subject "Subject to function"
aws lambda add-permission --function-name display_event --source-arn $TopicArn --action "lambda:InvokeFunction"  --principal sns.amazonaws.com  --statement-id grant-topic-access-to-function
aws lambda add-permission --function-name display_event --source-arn $TopicArn --action "lambda:InvokeFunction"  --principal sns.amazonaws.com  --statement-id grant-topic-access-to-function2
aws sns publish --topic-arn $TOpicArn --message "Message to function 2" --subject "Subject to function 2"
aws sns publish --topic-arn $TOpicArn --message "Message to function 3" 
git add display_event.py
git status
git add sns_to_lambda_demo.ps1
