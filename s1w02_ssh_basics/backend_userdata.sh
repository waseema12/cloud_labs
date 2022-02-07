#!/bin/bash

cd /home/ec2-user

# apply all software updates
yum -y update

# set up the region (to avoid issues later on)
su - -c "aws configure set default.region eu-west-1" ec2-user

# copy the contents of S3 bucket to home dir of ec2-user
#su - -c 'aws s3 cp --recursive s3://sshlabbackendsetup /home/ec2-user' ec2-user

# install python3
yum -y install python3

# install the boto3 python library (using pip)
pip3 install boto3

# make the python file executable
#chmod +x /home/ec2-user/keyqprocessor.py

# move the service unit file into the correct location
# (needs to be done as root)
#mv keyqprocessor.service.config /etc/systemd/system/keyqprocessor.service

# set up the service
#systemctl daemon-reload
#systemctl enable keyqprocessor
#systemctl start keyqprocessor

# add user accounts

