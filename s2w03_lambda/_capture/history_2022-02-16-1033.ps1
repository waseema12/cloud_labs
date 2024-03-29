cd ~/Desktop
ls
cd cloud_labs
git pull
./paste_credentials.ps1
./lab_checks.ps1
cd s2w03*
ls
aws lambda list-functions
ls 
cat hello_handler.py
Compress-Archive -Path hello_handler.py -Destination-Path hello_code.zip
Compress-Archive -Path hello_handler.py -DestinationPath hello_code.zip
aws lambda create-function help
aws sts get-caller-identity
$Account=(aws sts get-caller-identity | ConvertFrom-Json).Account
$RoleArn="arn:aws:iam::$($Account):role/LabRole"
aws lambda create-function --function-name hello3 --runtime python3.8 --handler hello_handler.hello_handler --zip-file fileb://hello_code.zip
aws lambda create-function --function-name hello3 --runtime python3.8 --handler hello_handler.hello_handler --zip-file fileb://hello_code.zip --role $RoleArn
aws lambda list-functions
cat hello_handler.py
cat payload.json
aws lambda invoke --function-name hello3 --payload fileb://payload.json out.txt
cat out.txt
ls
cd _capture
(Get-History).CommandLine 
(Get-History).CommandLine | Out-File history_2022-02-16-0926.ps1
git add *.ps1
git commit -m 'added from class'
git push 
git status
cd ../s2w02*
cd ..
ls
ls -l
ls
cd _capture
ls
ls
ls -l
cd ..
ls
ls -l
cp hello_handler.py display_event.py 
cp ../s2w02*/queue_policy_template.json . 
cp ../s2w02*/not*template.json . 
cp ../s2w02*/topic*template.json . 
ls
mv integration_demo.ps1 lambda_lab_setup.ps1
./lambda_lab_setup.ps1
./lambda_lab_setup.ps1
./lambda_lab_setup.ps1
ls
./lambda_lab_setup.ps1
$QueueUrl
ls
zaws lambda create-function --function-name display_event --handler display_event.display_event --runtime python3.8 --role $RoleArn --zip-file 
Compress-Archive -Path display_event.py -DestinationPath display_code.zip
aws lambda create-function --function-name display_event --handler display_event.display_event --runtime python3.8 --role $RoleArn --zip-file fileb://display_code.zip
aws lambda invoke --function-name display_event --payload fileb://payload.json
aws lambda invoke --function-name display_event --payload fileb://payload.json out.txt
cat out.txt
Compress-Archive -Path display_event.py -DestinationPath display_code.zip
Compress-Archive -Path display_event.py -DestinationPath display_code.zip -Force
aws lambda update-function-code 
aws lambda update-function-code --function-name display_event --zip-file fileb://display_code.zip
aws lambda invoke --function-name display_event --payload fileb://payload.json out.txt
cat out.txt
Compress-Archive -Path display_event.py -DestinationPath display_code.zip -Force
aws lambda update-function-code --function-name display_event --zip-file fileb://display_code.zip
aws lambda invoke --function-name display_event --payload fileb://payload.json out.txt
cat out.txt
aws sns subscribe 
aws sns subscribe help 
aws lambda list-functions
aws lambda list-functions help 
aws lambda help 
aws lambda get-function --function-name display_evenmt
aws lambda get-function --function-name display_event
(aws lambda get-function --function-name display_event | ConvertFrom-Json).Configuration.FunctionArn
$FunctionArn = (aws lambda get-function --function-name display_event | ConvertFrom-Json).Configuration.FunctionArn
aws sns subscribe --topic-arn $TopicArn --protocol lambda --notification-endpoint $FunctionArn 
aws sns publish --topic-arn $TopicArn --message xyz
# granting sns permissions to lambda
aws lambda add-permission --function-name display_event --source-arn $TopicArn --action "lambda:InvokeFunction"  --principal sns.amazonaws.com 
aws lambda add-permission --function-name display_event --source-arn $TopicArn --action "lambda:InvokeFunction"  --principal sns.amazonaws.com  --statement-id grant-topic-access-to-function
aws sns publish --topic-arn $TopicArn --message xyz
aws sns publish --topic-arn $TopicArn --message xyz
aws sns get-subscriptions
aws sns list-subscriptions-by-topic 
aws sns list-subscriptions-by-topic --topic-arn $TopicArn 
$Subscriptions = (aws sns list-subscriptions-by-topic --topic-arn $TopicArn | ConvertFrom-Json).Subscriptions 
foreach ( $subscription in $Subscriptions ) { Write-Host $Subscription.SubscriptionArn } 
foreach ( $subscription in $Subscriptions ) { aws sns unsubscribe --subscription-arn $Subscription.SubscriptionArn } 
aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn --attributes RawMessageDelivery=true
aws sns publish --topic-arn $TopicArn --message xyz1
aws sns subscribe --topic-arn $TopicArn --protocol lambda --notification-endpoint $FunctionArn --attributes RawMessageDelivery=true
aws sns subscribe --topic-arn $TopicArn --protocol lambda --notification-endpoint $FunctionArn 
aws sns publish --topic-arn $TopicArn --message xyz22
Compress-Archive -Path display_event.py -DestinationPath display_code.zip -Force
aws lambda update-function-code --function-name display_event --zip-file fileb://display_code.zip
aws sns publish --topic-arn $TopicArn --message xyz2200
Compress-Archive -Path display_event.py -DestinationPath display_code.zip -Force
aws lambda update-function-code --function-name display_event --zip-file fileb://display_code.zip
aws sns publish --topic-arn $TopicArn --message xyz220000
git status
git add display_event.py
git lambda_lab_setup.ps1
git add lambda_lab_setup.ps1
git add queue_policy_template.json
git status
cd _capture
ls
