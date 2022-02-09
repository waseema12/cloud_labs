cd Desktop/cloud_labs
git pull 
cd s2w02*
ls
cd ..
ls
./learner_lab.ps1
./paste_credentials.ps1
./lab_checks.ps1
cd s2w02*
ls
$TopicArn = (aws sns create-topic --name lecturetopic | ConvertFrom-Json).TopicArn
Write-Host "Topic ARN: $TopicArn"
$QueueUrl = (aws sqs create-queue --queue-name lecturequeue | ConvertFrom-Json).QueueUrl
Write-Host "Queue URL: $QueueUrl"
aws sns subscribe --topic-arn $TopicArn  --protocol email --notification-endpoint Peadar.Grant@dkit.ie
$QueueArn = (aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn | ConvertFrom-Json ).Attributes.QueueArn 
Write-Host "Queue ARN: $QueueArn"
aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn
$TopicArn
$QueueUrl
$QueueArn
Get-Content queue_policy_template.json 
Get-Content queue_policy_template.json | ConvertFrom-Json
$Policy = Get-Content queue_policy_template.json | ConvertFrom-Json
$Policy.Statement[0]
$Policy.Statement[0].Resource
$Policy.Statement[0].Resource = $QueueArn
$Policy.Statement[0]
$Policy.Statement[0].Condition
$Policy.Statement[0].Condition.arnEquals.'aws:sourceArn'=$TopicArn
$Policy.Statement[0]
$Policy.Statement[0] | ConvertTo-Json -Depth 99
$Attributes = @{ Policy=($Policy | ConvertTo-Json -Depth 99) }
$Attributes
$Attributes.Policy
$Attributes | ConvertTo-Json -Depth 99 | Out-File queue_attributes.json -Encoding ascii
aws sqs set-queue-attributes --attributes file://queue_attributes.json --queue-url $QueueUrl
$QueueUrl
aws sns publish --topic-arn $TopicArn --subject 'its working' --message 'its working'
cd _capture
ls
ls 

# queue processor
cd ../s1w08_sqs_basics
./consumer.ps1 
# then copy in queue URL when asked.

