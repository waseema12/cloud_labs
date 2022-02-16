# Subscribing a lambda function to an SNS topic
# Peadar Grant

# Assume lambda lab setup is done already, if not: 
./lambda_lab_setup.ps1
# and that $TopicArn, $QueueUrl, $QueueArn all exist

# Using display_event.py's display_event function, we
# Make our deployment package
Compress-Archive -Path display_event.py -DestinationPath display_event.zip

# Get our LabRole (for student accounts)
$Account=(aws sts get-caller-identity | ConvertFrom-Json).Account
$RoleArn="arn:aws:iam::$($Account):role/LabRole"

# Create function
aws lambda create-function --function-name display_event --runtime python3.8 --handler display_event.display_event --role $RoleArn --zip-file fileb://display_event.zip

# Get function ARN
$FunctionArn = (aws lambda get-function --function-name display_event | ConvertFrom-Json).Configuration.FunctionArn

# Subscribe
aws sns subscribe --topic-arn $TopicArn --protocol lambda --notification-endpoint $FunctionArn

# Add permissions
aws lambda add-permission --function-name display_event --source-arn $TopicArn --action "lambda:InvokeFunction"  --principal sns.amazonaws.com  --statement-id grant-topic-access-to-function

# Send message
aws sns publish --topic-arn $TopicArn --message "test message"

# view cloudwatch logs:
# https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#