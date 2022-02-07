#!/usr/bin/env python3

import boto3
import sys
import time

queue_name='sshlabq'

sqs = boto3.resource("sqs")
queue = sqs.get_queue_by_name(QueueName=queue_name)

print('Connected to %s' % queue_name)

# loop through queue
while True:
    for message in queue.receive_messages(WaitTimeSeconds=20):
        print(message.body)
        # work goes here
        message.delete()

