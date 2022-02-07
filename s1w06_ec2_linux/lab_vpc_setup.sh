#!/usr/bin/env bash

VPC_PREFIX=LAB
CIDR_BLOCK=10.0.0.0/16
SUBNET_CIDR_BLOCK=10.0.1.0/24

# Bail out if the LAB_VPC already exists
VPCS_INFO=$(aws ec2 describe-vpcs --filter Name=tag:Name,Values=${VPC_PREFIX}_VPC)
MATCHING_VPCS=$(echo ${VPCS_INFO} | jq '.Vpcs | length')
echo checking for ${VPC_PREFIX}_VPC: ${MATCHING_VPCS}
if (( MATCHING_VPCS > 0  ))
then
    echo ${VPC_PREFIX}_VPC already exists, exiting
    exit
fi

# VPC
VPC_INFO=$(aws ec2 create-vpc --cidr-block ${CIDR_BLOCK})
VPC_ID=$(echo ${VPC_INFO} | jq -r .Vpc.VpcId )
echo VPC ID: ${VPC_ID}
aws ec2 create-tags --resources ${VPC_ID} --tags Key=Name,Value=${VPC_PREFIX}_VPC

# SUBNET
SUBNET_INFO=$(aws ec2 create-subnet --cidr-block ${SUBNET_CIDR_BLOCK} --vpc-id ${VPC_ID})
SUBNET_ID=$(echo ${SUBNET_INFO} | jq -r .Subnet.SubnetId )
echo SUBNET ID: ${SUBNET_ID}
aws ec2 create-tags --resources ${SUBNET_ID} --tags Key=Name,Value=${VPC_PREFIX}_1_SN

# INTERNET GATEWAY
IGW_INFO=$(aws ec2 create-internet-gateway)
IGW_ID=$(echo ${IGW_INFO} | jq -r .InternetGateway.InternetGatewayId)
echo IGW ID: ${IGW_ID}
aws ec2 create-tags --resources ${IGW_ID} --tags Key=Name,Value=${VPC_PREFIX}_IGW
aws ec2 attach-internet-gateway --internet-gateway-id ${IGW_ID} --vpc-id ${VPC_ID}

# ROUTE TABLE
ROUTE_TABLE_INFO=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=${VPC_ID})
ROUTE_TABLE_ID=$(echo ${ROUTE_TABLE_INFO} | jq -r .RouteTables[0].RouteTableId )
echo ROUTE TABLE ID: ${ROUTE_TABLE_ID}
aws ec2 create-tags --resources ${ROUTE_TABLE_ID} --tags Key=Name,Value=${VPC_PREFIX}_RTB
aws ec2 create-route --route-table-id ${ROUTE_TABLE_ID} \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id ${IGW_ID}

