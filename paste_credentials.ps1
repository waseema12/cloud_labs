#!/usr/bin/env pwsh
# script to paste AWS Academy credentials into config dir

$AWSConfigDir = "~/.aws"

If(!(test-path $AWSConfigDir))
{
    Write-Host "creating AWS config directory $AWSConfigDir"
    New-Item -ItemType Directory -Force -Path $AWSConfigDir
}

$Credentials = Get-Clipboard 

# check that credentials match pattern
#if ( $Credentials -notlike '*aws_access_key_id*' ) {
#    Write-Error "clipboard content is not aws credentials"
#    Return
#}

$Credentials | Out-File ~/.aws/credentials -Encoding ascii

Write-Host pasted into credentials file

"[default]
region=us-east-1" | Out-File ~/.aws/config -Encoding ascii

Write-Host created config file

Write-Host "run lab_checks.ps1 to confirm correct setup"


