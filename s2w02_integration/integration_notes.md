---
title: PaaS Integration
---

Integration
===========

Successful integration of two services requires:

Identification

:   of the entities that need to communicate.

Permissions

:   to enable one service to invoke actions on the other.

Message formats

:   and transformations / settings that may be needed so our message
    arrives as intended.

SQS Endpoints for SNS
=====================

SNS is an important integration component along with SQS. We will study
more advanced architectures later on, but for now: SNS can be used to
deliver a message to an SQS queue.

An SQS queue is subscribed as an endpoint to an SNS topic. There will
normally be other subscribers: SQS queues and other endpoint types.

Setup
-----

We setup the `lab-topic` and the `lab-queue`:

``` {.powershell}
# Setup SNS topic
$TopicArn=(aws sns create-topic --name lab-topic | ConvertFrom-Json).TopicArn

# Setup SQS queue
$QueueUrl=(aws sqs create-queue --queue-name lab-queue | ConvertFrom-Json).QueueUrl
```

For testing, we may want to add an email (or other) subscription:

``` {.powershell}
aws sns subscribe --topic-arn $TopicARN --protocol email `
--notification-endpoint "someone@somewhere.com"
#        your e-mail goes here ----^
```

Subscribing
-----------

Subscription is created using sqs protocol and the queue ARN (not URL)
as Endpoint.

``` {.powershell}
# Get QueueARN for URL
$QueueArn=(aws sqs get-queue-attributes --queue-url $QueueUrl --attribute-names QueueArn | ConvertFrom-Json).Attributes.QueueArn

# Subscribe the queue to the topic
aws sns subscribe --topic-arn $TopicArn --protocol sqs --notification-endpoint $QueueArn  --attributes RawMessageDelivery=true 
```

The `RawMessageDelivery` attribute means that the message will be passed
directly as published to SNS into the queue. If this is omitted or set
to false, the message will be wrapped in JSON that includes SNS
meta-data.

To send a test message:

``` {.powershell}
aws sns publish --topic-arn $TopicARN --message "XYZ"
```

This will silently be dropped as SNS has no permission to send messages
published to the topic to the SQS queue.

Policy
------

AWS permissions need to be modified to permit SNS to send a message to
the SQS queue.

### Policy definition

First we need to define a policy for the `lab-queue` resource: Points to
note:

Principal

:   here is the SNS service.

Action

:   is to allow the `sqs:SendMessage`

Resource

:   is the ARN of the Queue itself.

Condition

:   needed to lock down the source topic. Without the condition item,
    this policy would allow any SNS topic to send messages to the queue.
    Here we require that the source of actin is the ARN of the topic.

### Generating attributes JSON

The policy is technically an attribute of the SQS queue. Attributes are
specified in a JSON document input to `aws` `sqs`
`set-queue-attributes`.

``` {.json}
{
  "Policy": "Policy goes here as string of JSON policy"
}
```

Rather than writing the policy out, we can generate one and include it
in a JSON file of attributes. Starting with the following template file
named `queue_policy_template.json`:

We can use PowerShell to fill in the ARNs:

``` {.powershell}
# read the JSON policy file and convert to Powershell objects
$Policy = Get-Content queue_policy_template.json | ConvertFrom-Json

# modify for the correct ARNs
$Policy.Statement[0].Resource=$QueueARN
$Policy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$TopicARN
# note we need to quote due to colon---------^
```

We can now create the attributes object in PowerShell which we’ll
convert to our JSON attributes file:

``` {.powershell}
# create hash with Policy with policy JSON *as string*
$Attributes = @{ Policy=($Policy | ConvertTo-Json -Depth 99) }
#         converts JSON to string--^

# optional: see how the JSON looks when wrapped inside outer JSON
$Attributes | ConvertTo-Json -Depth 99

# save the attributes
$Attributes | ConvertTo-Json -Depth 99 |  Out-File queue_attributes.json -Encoding ascii
```

### Applying queue attributes

``` {.powershell}
aws sqs set-queue-attributes --attributes file://queue_attributes.json --queue-url $QueueUrl
```

Testing
-------

To again send a test message:

``` {.powershell}
aws sns publish --topic-arn $TopicARN --message "XYZ"
```

Which this time should appear on the SQS queue:

``` {.powershell}
# receive the message
$ReceivedMessage=(aws sqs receive-message --queue-url $QueueUrl | ConvertFrom-Json).Messages[0]

# delete the message
aws sqs delete-message --queue-url $QueueUrl --receipt-handle $ReceivedMessage.ReceiptHandle
```

S3 as publisher to SNS
======================

Setup
-----

Assume we have an S3 bucket and SNS topic located in a given region:

``` {.powershell}
# S3 bucket
$BucketName="notifier-source-2" # choose unique name
aws s3api create-bucket --bucket $BucketName

# Generate the bucket ARN (always this pattern)
$BucketArn = "arn:aws:s3:::$BucketName"


Permissions
-----------

S3 must be granted permissions to publish messages to the SNS topic.
This permission is granted in a resource policy on the SNS topic. Unlike
SQS, SNS has a default non-empty resource policy, which we will need to
modify.

### Generating policy

We can build our policy from a template JSON file
`topic_policy_template.json`:

``` {.powershell}
# read in the template file
$NewPolicy = Get-Content topic_policy_template.json | ConvertFrom-Json

# fill in the Topic ARN as the resource
$NewPolicy.Statement[0].Resource=$TopicArn

# fill in the S3 bucket ARN in the condition
$NewPolicy.Statement[0].Condition.ArnEquals.'aws:SourceArn'=$BucketArn
```

### Adding to existing policy

Next, we must get the existing policy which is itself a JSON encoded
text attribute.

``` {.powershell}
# read in the attributes
$Attributes=(aws sns get-topic-attributes --topic-arn $TopicArn | ConvertFrom-Json)

# get the existing policy as PowerShell object
$Policy = $Attributes.Attributes.Policy | ConvertFrom-Json

# add the statement from the New policy on to the existing policy
$Policy.Statement += $NewPolicy.Statement[0]

# JSON encode the amended policy and output to file
$Policy | ConvertTo-Json -Depth 99 | Out-File topic_policy.json -Encoding ascii
```

### Applying amended policy

``` {.powershell}
aws sns set-topic-attribute --topic-arn $TopicArn `
--attribute-name Policy `
--attribute-value file://topic_policy.json
```

Setting up notification
-----------------------

Notification configurations tell S3 to send events to SNS (and other
destinations). A basic configuration template is:

We will use Powershell to read in this file and make some changes

``` {.powershell}
# read in the config file and convert to PSobject
$NotificationConfig = Get-Content notification_config_template.json | ConvertFrom-Json

# fill in the topic ARN
$NotificationConfig.TopicConfigurations[0].TopicArn=$TopicArn

# can modify other things as necessary!

# re-write
$NotificationConfig | ConvertTo-Json -Depth 99 | Out-File notification_config.json -Encoding ascii

aws s3api put-bucket-notification-configuration `
--bucket $BucketName `
--notification-configuration file://notification_config.json
```
