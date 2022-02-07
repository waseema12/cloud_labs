This lab exercise builds core skills for creating VPCs and EC2
instances.

VPC creation
============

VPC design
----------

1.  Draw out a diagram for a VPC named `LAB_VPC` using the 10.0.0.0/16
    CIDR block with one subnet using the 10.0.1.0/24 CIDR block named
    `LAB_1_SN` and an internet gateway named `LAB_IGW`.

2.  Write down (in words) the two rules that should govern the
    network routing.

VPC creation using console
--------------------------

1.  Use the web console to create this VPC in AWS. Use the PowerShell
    script [check\_lab\_vpc.ps1](check_lab_vpc.ps1) to check your work.

2.  Delete the VPC.

VPC creation using CLI
----------------------

1.  Use the AWS CLI (in PowerShell or Bash) to manually create the VPC
    using copy/paste of the IDs.

2.  Use the PowerShell script [check\_lab\_vpc.ps1](check_lab_vpc.ps1)
    to check your work.

EC2 setup
=========

Assuming your `LAB_VPC` is setup already:

1.  Create a security group named `LAB_SG` that allows SSH traffic
    inbound, and permits all traffic outbound.

2.  Upload your private key to AWS (if not already there).

3.  Create an EC2 instance using Amazon Linux with the `t2.nano` type:

    1.  Look up the AMI ID automatically.

    2.  Attach your security group and key pair to it.

    3.  The default instance storage is fine.

4.  When the instance has started running, look at the screenshot and
    confirm its sitting at the login screen.

5.  Use the ssh command in PowerShell / bash to connect to it. Use
    `ec2-user` and your private key as credentials. You will be at a
    standard bash prompt.

6.  Apply system updates as suggested in the prompt.

EC2 termination
---------------

Terminate your EC2 instance using the AWS CLI.

Automated setup
===============

1.  Write a script in PowerShell (or Bash) to:

    -   exit immediately if a VPC named/tagged `LAB_VPC` already exists.

    -   setup a VPC named/tagged `LAB_VPC` using the CIDR block given.

    -   create one subnet named/tagged `LAB_1_SN` using the CIDR
        block given.

    -   create an internet gateway and attach it to the VPC.

    -   route all traffic to addresses outside of the VPC through the
        internet gateway

2.  Write a script in Powershell (or Bash) to remove the `LAB_VPC` you
    built automatically. You will have to remove dependent components
    first. Suggested steps:

    1.  Get the VPC id corresponding to the `LAB_VPC` by parsing the
        JSON from the `describe-vpcs` command.

    2.  Get the internet gateway ID and delete it.

    3.  Get the subnet ids within this VPC (there will only be
        one here). Make sure to filter only the relevant subnets - you
        may have multiple VPCs later!


