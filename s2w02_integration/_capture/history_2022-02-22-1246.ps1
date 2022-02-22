cd ~/Desktop
ls
cd cloud_labs
git pull
./learner_labs.ps1
./learner_lab.ps1
cd s2w02*
ls
cd ..
./paste_credentials.ps1
./lab_checks.ps1
cd s2w02*
ls
$TopicName = 'lecture2topic'
$QueueName = 'lecture2queue'
$TopicArn = (aws sns create-topic --name lecturetopic | ConvertFrom-Json).TopicArn
Write-Host "Topic ARN: $TopicArn"
$QueueUrl = (aws sqs create-queue --queue-name lecturequeue | ConvertFrom-Json).QueueUrl
Write-Host "Queue URL: $QueueUrl"$QueueArn = (aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn | ConvertFrom-Json ).Attributes.QueueArn 
Write-Host "Queue ARN: $QueueArn"
$QueueArn = (aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn | ConvertFrom-Json ).Attributes.QueueArn
Write-Host "Queue ARN: $QueueArn"
$QueueUrl = (aws sqs create-queue --queue-name $QueueName | ConvertFrom-Json).QueueUrl
$QueueArn = (aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn | ConvertFrom-Json ).Attributes.QueueArn 
$QueueArn
$QueueUrl
aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn
aws sns publish --topic-arn $TopicArn --subject "M1" --message "M1"
$Policy = Get-Content queue_policy_template.json | ConvertFrom-Json
$Policy.Statement[0].Resource=$QueueArn
$Policy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$TopicArn
$Attributes = @{ Policy=($Policy | ConvertTo-Json -Depth 99) }
$Attributes | ConvertTo-Json -Depth 99 | Out-File  queue_attributes.json -Encoding ascii
aws sqs set-queue-attributes --attributes file://queue_attributes.json --queue-url $QueueUrl
aws sns publish --topic-arn $TopicArn --subject "M1" --message "M1"
$BucketName="notifier-source-2000"
aws s3api create-bucket --bucket $BucketName
$BucketArn = "arn:aws:s3:::$BucketName"
$NewPolicy = Get-Content topic_policy_template.json | ConvertFrom-Json 
$NewPolicy.Statement[0].Resource
$NewPolicy.Statement[0].Resource=$TopicArn
$NewPolicy.Statement[0].Condition
$NewPolicy.Statement[0].Condition.ArnEquals.'aws:SourceArn'
$NewPolicy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$BucketArn
$NewPolicy.Statement[0].Condition.ArnEquals.'aws:SourceArn'
$Attributes=(aws sns get-topic-attributes --topic-arn $TopicArn | ConvertFrom-Json)
$Policy = $Attributes.Attributes.Policy | ConvertFrom-Json
$Policy
$Policy |ConvertTo-Json -Depth 99
$TopicArn
$NewPolicy.Statement[0].Sid
$NewPolicy.Statement[0].Sid=allow-s3-sns-2000
$NewPolicy.Statement[0].Sid='allow-s3-sns-2000'
$Policy.Statement += $NewPolicy.Statement[0]
$Policy.Statement
$Policy | ConvertTo-Json -Depth 99 | Out-File topic_policy.json -Encoding ascii
aws sns set-topic-attribute --topic-arn $TopicArn --attribute-name Policy --attribute-value file://topic_policy.json
aws sns set-topic-attributes --topic-arn $TopicArn --attribute-name Policy --attribute-value file://topic_policy.json
$NotificationConfig = Get-Content notification_config_template.json | ConvertFrom-Json
$NotificationConfig.TopicConfigurations
$NotificationConfig.TopicConfigurations[0]
$NotificationConfig.TopicConfigurations[0].TopicArn 
$NotificationConfig.TopicConfigurations[0].TopicArn = $TopicArn
$NotificationConfig.TopicConfigurations[0].TopicArn 
$NotificationConfig | ConvertTo-Json -Depth 99 | Out-File notification_config.json -Encoding ascii
aws s3api put-bucket-notification-configuration 
aws s3api put-bucket-notification-configuration --bucket $BucketName --notification-configuration file://notification_config.json 
$TopicArn
clear
ls
aws s3 cp sns_to_sqs.gv s3://$BucketName/sns_to_sqs.gv
cd ../s2w04*
cd ..
ls
clear
ls
cd s2w02*
./save_history.ps1
