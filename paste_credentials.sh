#!/bin/bash
# script to paste AWS Academy credentials into lab

Credentials="$(pbpaste)"

echo "$Credentials" > ~/.aws/credentials

echo pasted into credentials file

echo '[default]
region = us-east-1
' > ~/.aws/config


