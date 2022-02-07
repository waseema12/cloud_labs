% EC2 linux usage

# Lab setup (reminder)

Start Lab.
Copy credentials.
Use `.\paste_credentials.ps1` to paste into correct place.
Use `.\lab_checks.ps1` to confirm your credentials are working.

# Create EC2 and VPC

Go into the console and delete any existing EC2 and VPCs you have created in labs.

Create an EC2 instance with the following setup using PowerShell:

- VPC 10.0.0.0/16
- Subnet 10.0.0.0/24
- Amazon Linux 2 AMI 
- Type `t2.nano`
- Internet gateway attached to VPC
- Route all traffic 0.0.0.0/0 via internet gateway
- SSH traffic allowed in
- Use `vockey` as key (to use web SSH console)

Get a copy of your Powershell history.

Connect to your instance using SSH.

# Linux familiarisation

These tasks are to re-familisarise you with Linux.
Attempt these while logged in to Amazon Linux.

## Yum

Use `yum` to update all software


## Git

Use `yum` to install git.

Try to checkout this repository on the EC2 instance.


## Text editor

Use the `nano` text editor to modify this file some way.


## Web server

Install apache web server:

	yum -y install httpd

Enable to start

	sudo systemctl enable httpd

Start now

	sudo systemctl start httpd

Try to connect to your instance's public IP from your browser over HTTP (not HTTPS!).

You will find it won't work.
This is because security group is not letting traffic in.
Use `authorize-security-group-ingress` to permit traffic in on the correct port.
Try to connect from your browser again.


## Website

For this exercise, use a STATIC website you have built yourself.
Use SFTP to upload it to your instance.

If you don't have one handy, you can get one at https://github.com/peadargrant/test_static_website
You can either use git to clone it to your desktop and then SFTP, or else just git directly on the EC2 instance.


# Instance operations

## Stop / start

	aws ec2 stop-instances

	aws ec2 start-instances

## Terminate

	aws ec2 terminate-instances



