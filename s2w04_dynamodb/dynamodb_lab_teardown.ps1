# DynamoDB lab teardown script
# Peadar Grant
# Setup file

$TopicName = 'dynamotopic'
$QueueName = 'dynamoqueue'
$FunctionName = 'log_message'
$TableName = 'message_table'

aws sns delete-topic --topic-arn $TopicArn
aws sqs delete-queue --queue-url $QueueUrl
aws lambda delete-function --function-name $FunctionName
aws dynamodb delete-table --table-name $TableName

