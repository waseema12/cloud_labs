# script to tear down lab VPC environment

$Vpcs=(aws ec2 describe-vpcs --filter Name=tag:Name,Values=LAB_VPC | ConvertFrom-Json).Vpcs

Write-Host "Found $($Vpcs.Count) matching VPCs to delete"

ForEach ( $Vpc in $Vpcs) {

    Write-Host "VpcId $($Vpc.VpcId)"

    $Subnets=(aws ec2 describe-subnets --filter Name=vpc-id,Values=$($Vpc.VpcId) | ConvertFrom-Json).Subnets
    ForEach ( $Subnet in $Subnets ) {
        Write-Host "Subnet $($Subnet.SubnetId)";
        aws ec2 delete-subnet --subnet-id $($Subnet.SubnetId)
    }

    $IGWs=(aws ec2 describe-internet-gateways --filter Name=attachment.vpc-id,Values=$($Vpc.VpcId)| ConvertFrom-Json).InternetGateways
    ForEach ( $IGW in $IGWs ) {
        Write-Host "IGW $($IGW.InternetGatewayId)";
        aws ec2 detach-internet-gateway --internet-gateway-id $($IGW.InternetGatewayId) --vpc-id $($Vpc.VpcId)
        aws ec2 delete-internet-gateway --internet-gateway-id $($IGW.InternetGatewayId)
    }

    aws ec2 delete-vpc --vpc-id $($Vpc.VpcId)

}

