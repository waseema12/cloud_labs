cd ~
cd Desktop
ls
cd cloud_labs
git pull
./learner_lab.ps1
./paste_credentials.ps1
./lab_checks.ps1
cd s2w02*
ls
aws sns create-topic --name lecture2topic
$TopicArn='arn:aws:sns:us-east-1:381303118602:lecture2topic'
aws sns create-queue --queue-name lecture2queue
aws sqs create-queue --queue-name lecture2queue
$QueueUrl='https://queue.amazonaws.com/381303118602/lecture2queue'
$QueueUrl = (aws sqs create-queue --queue-name lecturequeue | ConvertFrom-Json).QueueUrl
$QueueUrl
aws sns subscribe --topic-arn $TopicArn  --protocol email --notification-endpoint Peadar.Grant@dkit.ie
aws sqs get-queue-attributes --queue-url $QueueUrl 
aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-name QueueArn
$QueueArn = ( aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-name QueueArn | ConvertFrom-Json).Attributes.QueueArn
$QueueArn
aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn 
$QueueUrl 
aws sns publish --topic-arn $TopicArn --message xyz
ls
$Policy = (Get-Content queue_policy_template.json | ConvertFrom-Json)
$Policy
$Policy.Statement[0].Resource
$Policy.Statement[0].Resource=$QueueArn
$Policy.Statement[0].Resource
$Policy.Statement[0].Condition.ArnEquals
$Policy.Statement[0].Condition.ArnEquals.aws:sourceArn
$Policy.Statement[0].Condition.ArnEquals.'aws:sourceArn'
$Policy.Statement[0].Condition.ArnEquals.'aws:sourceArn'=$TopicArn
$Policy | ConvertTo-Json 
$Policy | ConvertTo-Json -Depth 99 
$Attributes = @{ Policy=($Policy | ConvertTo-Json -Depth 99)} 
$Attributes
$Attributes.Policy
$Attributes | ConvertTo-Json 
$Attributes | ConvertTo-Json | Out-File queue_attributes.json -Encoding ascii 
aws sqs set-queue-attributes --attributes file://queue_attributes.json --queue-url $QueueUrl 
aws sns publish --topic-arn $TopicArn --message xyz22
aws sns subscribe
aws sns subscribe help
git status
git status
git pull
Get-History
Get-History.CommandLine
mkdir _capture
cd _capture
