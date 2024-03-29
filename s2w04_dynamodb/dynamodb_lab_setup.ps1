# Lambda lab setup
# Peadar Grant
# Setup file

$TopicName = 'dynamotopic'
$QueueName = 'dynamoqueue'

$global:TopicName=$TopicName
$global:QueueName=$QueueName

# create the SNS topic, capturing the ARN
$TopicArn = (aws sns create-topic --name $TopicName | ConvertFrom-Json).TopicArn
Write-Host "Topic ARN: $TopicArn"
$global:TopicArn=$TopicArn

# create the SQS queue, capture the Queue URL
$QueueUrl = (aws sqs create-queue --queue-name $QueueName | ConvertFrom-Json).QueueUrl
Write-Host "Queue URL: $QueueUrl"
$global:QueueUrl=$QueueUrl

# lookup the queue ARN
$QueueArn = (aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn | ConvertFrom-Json ).Attributes.QueueArn 
Write-Host "Queue ARN: $QueueArn"
$global:QueueArn=$QueueArn

# subscribe the Queue to the Topic
aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn

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

