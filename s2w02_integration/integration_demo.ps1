# Integration demo commands
# Peadar Grant
# This is not intended to be run as a script, rather just for info.
#
# You should work through this file.
# Confirm that you understand each step before moving on.

$TopicName = 'lecture2topic'
$global:TopicName=$TopicName
$QueueName = 'lecture2queue'
$global:QueueName=$QueueName

# create the SNS topic, capturing the ARN
$TopicArn = (aws sns create-topic --name lecturetopic | ConvertFrom-Json).TopicArn
Write-Host "Topic ARN: $TopicArn"
$global:TopicArn=$TopicArn

# create the SQS queue, capture the Queue URL
$QueueUrl = (aws sqs create-queue --queue-name $QueueName | ConvertFrom-Json).QueueUrl
Write-Host "Queue URL: $QueueUrl"
$global:QueueUrl=$QueueUrl

# subscribe your email address
aws sns subscribe --topic-arn $TopicArn  --protocol email --notification-endpoint Peadar.Grant@dkit.ie

# lookup the queue ARN
$QueueArn = (aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn | ConvertFrom-Json ).Attributes.QueueArn 
Write-Host "Queue ARN: $QueueArn"
$global:QueueArn=$QueueArn

# subscribe the Queue to the Topic
aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn

# test message
aws sns publish --topic-arn $TopicArn --subject "M1" --message "M1"

# create a queue policy from the template
$Policy = Get-Content queue_policy_template.json | ConvertFrom-Json
$Policy.Statement[0].Resource=$QueueArn
$Policy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$TopicArn

# make an attributes JSON document
# this JSON embeds the Policy JSON as text (not nested JSON!)
$Attributes = @{ Policy=($Policy | ConvertTo-Json -Depth 99) }
$Attributes | ConvertTo-Json -Depth 99 | Out-File  queue_attributes.json -Encoding ascii

# set the queue attributes from our saved attributes
aws sqs set-queue-attributes --attributes file://queue_attributes.json --queue-url $QueueUrl

$BucketName="notifier-source-2" # choose unique name
$global:BucketName=$BucketName
aws s3api create-bucket --bucket $BucketName

# Generate the bucket ARN (always this pattern)
$BucketArn = "arn:aws:s3:::$BucketName"

$NewPolicy = Get-Content topic_policy_template.json | ConvertFrom-Json
# fill in the Topic ARN as the resource
$NewPolicy.Statement[0].Resource=$TopicArn
# fill in the S3 bucket ARN in the condition
$NewPolicy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$BucketArn

# read in the attributes
$Attributes=(aws sns get-topic-attributes --topic-arn $TopicArn | ConvertFrom-Json)
# get the existing policy as PowerShell object
$Policy = $Attributes.Attributes.Policy | ConvertFrom-Json
# add the statement from the New policy on to the existing policy
$Policy.Statement += $NewPolicy.Statement[0]
# JSON encode the amended policy and output to file
$Policy | ConvertTo-Json -Depth 99 | Out-File topic_policy.json -Encoding ascii
# Apply the amended policy
aws sns set-topic-attributes --topic-arn $TopicArn --attribute-name Policy --attribute-value file://topic_policy.json

# read in the config file and convert to PSobject
$NotificationConfig = Get-Content notification_config_template.json | ConvertFrom-Json
# fill in the topic ARN
$NotificationConfig.TopicConfigurations[0].TopicArn=$TopicArn
# write back the amended notification config
$NotificationConfig | ConvertTo-Json -Depth 99 | Out-File notification_config.json -Encoding ascii
# apply the notification configuration to the bucket
aws s3api put-bucket-notification-configuration `
--bucket $BucketName `
--notification-configuration file://notification_config.json

