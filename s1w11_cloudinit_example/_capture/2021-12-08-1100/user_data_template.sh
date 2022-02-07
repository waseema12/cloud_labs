#!/bin/bash
yum -y update

# change into root's home dir
cd /root

# set up the aws config for region
mkdir -p .aws
echo '[default]
region=us-east-1
' > .aws/config

# and copy that to the ec2 user
cp -r .aws /home/ec2-user
chown -R ec2-user /home/ec2-user/.aws

# install boto3 library
pip3 install boto3

BUCKET=__BUCKET__

# download python script
cd /home/ec2-user
aws s3 cp s3://$BUCKET/qprocessor.py qprocessor.py
chown -R ec2-user /home/ec2-user 

# download the service unit file to the correct folder
aws s3 cp s3://$BUCKET/qprocessor.service /etc/systemd/system/qprocessor.service

# install and run service
systemctl daemon-reload
systemctl enable qprocessor
systemctl start qprocessor

