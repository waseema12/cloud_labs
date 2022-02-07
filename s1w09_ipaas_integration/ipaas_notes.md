% Infrastructure / Platform as a service integration

EC2 access to S3 
================

EC2 is IaaS whilst S3, SQS is PaaS.
To connect them we need an IAM role. 
A role allows parts of AWS to take actions on your behalf
without your username/password or key/secret key.

A role is defined in terms of two **policies**.

Creating trust policy
---------------------

Create a new plain text file named `ec2-role-trust-policy.json` with the
following content:

Looking at the above policy, it contains one statement. Breaking it
down:

Effect

:   is either to `Allow` or `Deny`

Principal

:   is the AWS user that the statement is to apply to. The principal
    here is the EC2 service.

Action

:   is a *list* of actions to allow. Here we allow actions matching the
    `s3:*` pattern, basically anything to do with S3.

Resource

:   is a *list* of the AWS resources (primarily buckets and objects in
    this particular context) that this policy is to apply to. The
    asterisk \* means match any.

Create your new role
--------------------

A new role is created. The trust policy from above is used to define
who/what is allowed to assume the role.

``` {.powershell}
aws iam create-role --role-name s3access --assume-role-policy-document file://ec2-role-trust-policy.json
```

Create access policy
--------------------

The access policy determins what the role is allowed to do. Create a new
plain text file named `ec2-role-access-policy.json` with the following
contents:

The fields are the same as in the case of the trust policy. There is no
principal here, since the principal will be whatever role the policy is
attached to.

Attach policy
-------------

Attach the access policy to the role

``` {.powershell}
aws iam put-role-policy --role-name s3access --policy-name S3-Permissions --policy-document file://ec2-role-access-policy.json
```

Create instance profile
-----------------------

``` {.powershell}
aws iam create-instance-profile --instance-profile-name s3access-profile
```

Add role to instance profile
----------------------------

``` {.powershell}
aws iam add-role-to-instance-profile --instance-profile-name s3access-profile --role-name s3access
```

EC2 instance with instance profile
----------------------------------

``` {.powershell}
# run instance 
$InstanceId=( aws ec2 run-instances `
--subnet-id $SubnetId `
--instance-type t2.micro `
--security-group-ids $SGId `
--key-name LAB_KEY `
--iam-instance-profile Name=s3access-profile `
| ConvertFrom-Json ).Instances.InstanceId

# get public IP
$PublicIp = ( aws ec2 describe-instances `
--instance-id $InstanceId `
| ConvertFrom-Json ).Reservations.Instances.PublicIpAddress

# connect
ssh ec2-user@$PublicIp
```

Then inside the EC2 instance:

``` {.bash}
# then use AWS S3 commands without any extra config!
aws s3 list-buckets 

# commands needing region need region set (choose one:)
aws configure default-region us-east-1
aws configure default-region us-east-1
```
