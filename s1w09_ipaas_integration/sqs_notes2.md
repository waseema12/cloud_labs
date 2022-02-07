Queue processor example
=======================

A common usage pattern is that messages arrive into a queue for
processing by a continuously running server process. There are many
other patterns, such as an intermittent batch process, also.

Here we have a python script [qprocessor.py](qprocessor.py) that
receives messages from a queue `labq` and writes them to an S3 bucket
`labbucket-pg`. Although a trivial example it illustrates some important
points about queues and platform services. Code is:

Setup
-----

Download/run [sqs\_setup.ps1](sqs_setup.ps1) to setup the VPC
environment.

Create bucket
-------------

Create a bucket using the S3 API commands:

``` {.powershell}
aws s3api create-bucket --bucket labbucket-pg
# remember bucket names globally unique!
```

Create role
-----------

We need a role, which we’ll call `qprocessor`. The trust policy lets EC2
assume it, same as before:

We can then create the role `qprocessor`:

``` {.powershell}
aws iam create-role --role-name qprocessor --assume-role-policy-document file://qprocessor-trust-policy.json
```

Access policy
-------------

Here we will create an access policy
[qprocessor-access-policy.json](qprocessor-access-policy.json) to allow
writes to our s3 bucket and reads from our queue. Our policy looks like:

Then we attach the policy onto the role as `qprocessor-Permissions`:

``` {.powershell}
aws iam put-role-policy `
--role-name qprocessor
--policy-name qprocessor-Permissions
--policy-document file://qprocessor-access-policy.json
```

Create instance profile
-----------------------

``` {.powershell}
# create instance profile
aws iam create-instance-profile `
--instance-profile-name qprocessor-profile

# add role
aws iam add-role-to-instance-profile `
--instance-profile-name qprocessor-profile `
--role-name qprocessor
```

Create EC2 instance
-------------------

``` {.powershell}
# string to look up image ID
$ImageId="resolve:ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"

# run instance
$InstanceId=( aws ec2 run-instances `
--subnet-id $SubnetId `
--instance-type t2.micro `
--security-group-ids $SGId `
--key-name LAB_KEY `
--image-id $ImageId `
--iam-instance-profile Name=qprocessor-profile `
| ConvertFrom-Json).Instances.InstanceId 

# get public IP
$PublicIpAddress = (aws ec2 describe-instances `
--instance-id $InstanceId `
| ConvertFrom-Json).Reservations.Instances.PublicIpAddress

# connect
ssh ec2-user@$PublicIpAddress
```

Obtain qprocessor.py
--------------------

Use curl or download on your local PC and upload via SFTP to instance.

Modification
------------

Edit qprocessor.py to match the name of your bucket.

Run qprocessor
--------------

We can run the `qprocessor.py`:

``` {.bash}
./qprocessor.py
```

We can use the following to resolve issues:

``` {.bash}
# install python3 if needed
sudo yum -y install python3

# make executable if needs be
chmod +x ./qprocessor.py
man chmod # to learn more about chmod

# install dependencies 
sudo pip3 install boto3
```

Service unit file
-----------------

Services in linux need a service unit to tell the OS how to start and
run the service.

The service unit file can be either downloaded

Service installation
--------------------

Service installation on Linux follows a similar pattern to windows

``` {.bash}
# reload systemd unit files 
# run after any change 
sudo systemctl daemon-reload

# enable (so it starts on boot)
sudo systemctl enable qprocessor

# start
sudo systemctl start qprocessor
```

Clean-up
========

Don’t forget to terminate your ec2 instance, delete your bucket, delete
your queue, remove the role from instance profile, remove the instance
profile, remove the policy from the role, delete the role.
