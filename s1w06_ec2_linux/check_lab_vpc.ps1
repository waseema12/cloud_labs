# script to check lab VPC environment for VPC lab
# Peadar Grant

$CorrectVPCCIDRBlock="10.0.0.0/16"
$CorrectSubnetCIDRBlock="10.0.1.0/24"

$Vpcs=(aws ec2 describe-vpcs --filter Name=tag:Name,Values=LAB_VPC | ConvertFrom-Json).Vpcs

if ( $Vpcs.Count -lt 1 ) {
    throw "no VPC named LAB_VPC found"
}

if ( $Vpcs.Count -gt 1 ) {
    throw "found $($Vpcs.Count) VPCs named LAB_VPC - rename/delete so 1 left"
}

Write-Host "Found LAB_VPC"
$Vpc=$Vpcs[0]

Write-Host "VpcId $($Vpc.VpcId)"

if ( $Vpc.CidrBlock -eq $CorrectVPCCIDRBlock ) {
    Write-Host "CIDR block correct";
}
else {
    throw "CIDR block for VPC $($Vpc.CidrBlock) is incorrect (should be $CorrectVPCCIDRBlock)";
}

# confirm only one subnet in VPC
$Subnets=(aws ec2 describe-subnets --filter Name=vpc-id,Values=$($Vpc.VpcId)  --filter Name=tag:Name | ConvertFrom-Json).Subnets
if ( $Subnets.Count -gt 1 ) {
    throw "multiple subnets found in VPC - there should be one"
}

# confirm subnet with right name exists
$Subnets=(aws ec2 describe-subnets --filter Name=vpc-id,Values=$($Vpc.VpcId)  --filter Name=tag:Name,Values=LAB_1_SN | ConvertFrom-Json).Subnets
if ( $Subnets.Count -lt 1 ) {
    throw "no subnets in LAB_VPC named LAB_SN found - check names"
}

$Subnet=$Subnets[0]
Write-Host "Subnet $($Subnet.SubnetId)";

# check CIDR block
if ( $Subnet.CidrBlock -eq $CorrectSubnetCIDRBlock ) {
    Write-Host "CIDR block correct";
}
else {
    throw "CIDR block for Subnet $($Subnet.CidrBlock) incorrect (should be $CorrectSubnetCIDRBlock)";
}


$IGWs=(aws ec2 describe-internet-gateways --filter Name=attachment.vpc-id,Values=$($Vpc.VpcId)  --filter Name=tag:Name,Values=LAB_IGW | ConvertFrom-Json).InternetGateways

if ( $IGWs.Count -ne 1 ) {
    throw "$($IGWs.Count) Internet Gateways found (should be 1)"
}

$IGW=$IGWS[0];

Write-Host "IGW $($IGW.InternetGatewayId)";
if ( $IGW.Attachments.Count -eq 1 ) {
    Write-Host "internet gateway attached to VPC"
}
else {
    throw "internet gateway not attached to VPC - attach and try again"
}


$RTBs=(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$($Vpc.VpcId) | ConvertFrom-Json).RouteTables
if ( $RTBs.Count -gt 1 ) {
    throw "multiple route tables found for VPC - should be 1"
}
if ( $RTBs.Count -lt 1 ) {
    Write-Host "no route table found";
}

$RTB=$RTBs[0]
Write-Host "RTB $($RTB.RouteTableId)";

$internalRouteOk=$False
$externalRouteOk=$False

ForEach ( $Route in $RTB.Routes ) {
    if ( $Route.DestinationCidrBlock -eq $CorrectVPCCIDRBlock ) {
        Write-Host 'found internal route';
        $internalRouteOk=$True
    } 
    if ( $Route.DestinationCidrBlock -eq '0.0.0.0/0' ) {
        Write-Host 'found external route';
        if ( $Route.GatewayId -eq $IGW.InternetGatewayId ) {
            Write-Host 'external traffic routed to IGW'
            $externalRouteOk=$True
        }
    }
}

if ($False -eq $internalRouteOk) {
    throw 'internal routing is incorrect - check route table'
}
if ($False -eq $externalRouteOk) {
    throw 'external routing is incorrect - check route table'
}

Write-Host 'great job!  no issues found!'

