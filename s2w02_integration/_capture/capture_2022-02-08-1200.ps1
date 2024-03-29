cd ~
cd Desktop
ls
git clone https://github.com/peadargrant/cloud_labs.git
ls
cd cloud_*
ls
./learner_lab.ps1
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
./learner_lab.ps1
ls
./paste_credentials.ps1
mkdir ~/.aws
./paste_credentials.ps1
ls
./lab_checks.ps1
cd s2w02_integration
ls
aws sns create-topic --name lecturetopic
$TopicArn='arn:aws:sns:us-east-1:381303118602:lecturetopic'
aws sqs create-queue --queue-name lecturequeue
$QueueUrl='https://queue.amazonaws.com/381303118602/lecturequeue'
aws sns subscribe --topic-arn $TopicArn  --protocol email --notification-endpoint Peadar.Grant@dkit.ie
aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn
aws sqs get-queue-attributes --queue-url $QueueUrl 
$QueueArn='arn:aws:sqs:us-east-1:381303118602:lecturequeue'
aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn
aws sns publish --topic-arn --subject XYZ 
aws sns publish --topic-arn $TopicArn --subject XYZ --message XYZ2
aws sqs receive-message --queue-url $QueueUrl
$Policy = Get-Content queue_policy_template.json | ConvertFrom-Json
$Policy
$Policy.Statement
$Policy.Statement[0]
$Policy.Statement[0].Resource
$Policy.Statement[0].Resource=$QueueArn
$Policy.Statement[0]
$Policy.Statement[0].Condition
$Policy.Statement[0].Condition.ArnEquals
$Policy.Statement[0].Condition.ArnEquals.'aws:SourceArn'
$Policy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$TopicArn
$Policy.Statement[0]
$Policy.Statement[0].Condition
$Policy
$Policy | ConvertTo-Json
$Policy | ConvertTo-Json -Depth 99
$Policy | ConvertTo-Json -Depth 99 | Out-File queue_policy.json
$Attributes = @{ Policy=($Policy | ConvertTo-Json -Depth 99) }
$Attributes
$Attributes.Policy
$Attributes | ConvertTo-Json
$Attributes | ConvertTo-Json -Depth 99
$Attributes | ConvertTo-Json -Depth 99 | queue_attributes.json
$Attributes | ConvertTo-Json -Depth 99 |Out-File  queue_attributes.json
aws sqs set-queue-attributes --attributes file://queue_attributes.json --queue-url $QueueUrl
aws sqs set-queue-attributes --attributes fileb://queue_attributes.json --queue-url $QueueUrl
aws sqs set-queue-attributes --attributes fileb://queue_attributes.json --queue-url $QueueUrl
history
history -Raw
history 
history | ConvertTo-Text
Get-History | Out-File h1.ps1
(Get-History).CommandLine | Out-File h1.ps1
ls
./h1.ps1
$Policy = Get-Content queue_policy_template.json | ConvertFrom-Json
$Policy.Statement[0].Resource=$QueueArn
$Policy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$TopicArn
$Attributes = @{ Policy=($Policy | ConvertTo-Json -Depth 99) }
$Attributes | ConvertTo-Json -Depth 99 | Out-File  queue_attributes.json -Encoding ascii
$Attributes | ConvertTo-Json -Depth 99 | Out-File  queue_attributes.json -Encoding ascii
aws sqs set-queue-attributes --attributes file://queue_attributes.json --queue-url $QueueUrl
git status
git add integration_notes.md
git add queue_policy.json
mv h1.ps1 integration_demo.ps1
git status
git add integration_demo.ps1
mkdir _capture
cd _capture
Get-History
Get-History.CommandLine
(Get-History).CommandLine
