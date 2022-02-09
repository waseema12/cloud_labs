# Integration demo commands
# This is not intended to be run as a script, rather just for info.

$TopicArn = (aws sns create-topic --name lecturetopic | ConvertFrom-Json).TopicArn
Write-Host "Topic ARN: $TopicArn"

$QueueUrl = (aws sqs create-queue --queue-name lecturequeue | ConvertFrom-Json).QueueUrl
Write-Host "Queue URL: $QueueUrl"

aws sns subscribe --topic-arn $TopicArn  --protocol email --notification-endpoint Peadar.Grant@dkit.ie

$QueueArn = (aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn | ConvertFrom-Json ).Attributes.QueueArn 
Write-Host "Queue ARN: $QueueArn"

aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn

$Policy = Get-Content queue_policy_template.json | ConvertFrom-Json
$Policy.Statement[0].Resource=$QueueArn
$Policy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$TopicArn
$Attributes = @{ Policy=($Policy | ConvertTo-Json -Depth 99) }
$Attributes | ConvertTo-Json -Depth 99 | Out-File  queue_attributes.json -Encoding ascii

aws sqs set-queue-attributes --attributes file://queue_attributes.json --queue-url $QueueUrl
