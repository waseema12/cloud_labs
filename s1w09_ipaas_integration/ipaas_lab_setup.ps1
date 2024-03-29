﻿# script to setup lab VPC for EC2 lab
# Peadar Grant

$Vpcs=(aws ec2 describe-vpcs --filter Name=tag:Name,Values=LAB_VPC | ConvertFrom-Json).Vpcs

if ( $Vpcs.Count -ge 1 ) {
    throw "found $($Vpcs.Count) VPCs named LAB_VPC - rename/delete"
}

# create the vpc
$Vpc = (aws ec2 create-vpc --cidr-block 10.0.0.0/16 | ConvertFrom-Json ).Vpc
Write-Host "vpc-id $($Vpc.VpcId)"
aws ec2 create-tags --resources $Vpc.VpcId --tags Key=Name,Value=LAB_VPC

# create a subnet
$Subnet = (aws ec2 create-subnet --vpc-id $Vpc.VpcId --cidr-block 10.0.1.0/24 | ConvertFrom-Json).Subnet
Write-Host "subnet-id $($Subnet.SubnetId)"
aws ec2 create-tags --resources $Subnet.SubnetId --tags Key=Name,Value=LAB_1_SN

# turn on auto IP
aws ec2 modify-subnet-attribute --subnet-id $Subnet.SubnetId --map-public-ip-on-launch

# create and attach internet gateway
$IGW = (aws ec2 create-internet-gateway | ConvertFrom-Json).InternetGateway
Write-Host "internet-gateway-id $($IGW.InternetGatewayId)"
aws ec2 create-tags --resources $IGW.InternetGatewayId --tags Key=Name,Value=LAB_IGW
aws ec2 attach-internet-gateway --vpc-id $Vpc.VpcId --internet-gateway-id $IGW.InternetGatewayId

# add route to the route table
$RT = (aws ec2 describe-route-tables --filters Name=vpc-id,Values=$($Vpc.VpcId) | ConvertFrom-Json).RouteTables[0]
Write-Host "route-table-id $($RT.RouteTableId)"
aws ec2 create-tags --resources $RT.RouteTableId --tags Key=Name,Value=LAB_RTB
aws ec2 create-route --route-table-id $RT.RouteTableId --gateway-id $IGW.InternetGatewayId --destination-cidr-block 0.0.0.0/0

# create the security group
$SGId = (aws ec2 create-security-group --group-name LAB_SG --description LAB_SG --vpc-id $Vpc.VpcId | ConvertFrom-Json).GroupId
Write-Host "security-group-id $SGId"
aws ec2 authorize-security-group-ingress --group-id $SGId --protocol tcp --port 22 --cidr 0.0.0.0/0


