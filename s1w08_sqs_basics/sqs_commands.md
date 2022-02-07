% SQS Operations

# Creating a queue

Creating a queue

    aws sqs create-queue --queue-name $QName

Create a queue (and copy the Queue URL):

    $QUrl = (aws sqs create-queue --queue-name $QName | ConvertFrom-Json).QueueUrl

# Message handling

Send message to queue
	aws sqs send-message --queue-url $QUrl --message-body $Message
	
Receive message from queue
	$m = (aws sqs receive-message --queue-url $QUrl | ConvertFrom-Json).Messages[0]
	$m.Body 

Delete message
	aws sqs delete-message --queue-url $QUrl --receipt-handle $m.ReceiptHandle
	
Purge (empty a queue):
	aws sqs purge-queue --queue-url $QUrl

# Deleting a queue

Deleting queue:
	aws sqs delete-queue --queue-url $QUrl
	
	
	