cd ~/Desktop
ls
cd cloud_labs
git pull
./paste_credentials.ps1
./lab_checks.ps1
cd s2w03*
ls
aws lambda list-functions
ls 
cat hello_handler.py
Compress-Archive -Path hello_handler.py -Destination-Path hello_code.zip
Compress-Archive -Path hello_handler.py -DestinationPath hello_code.zip
aws lambda create-function help
aws sts get-caller-identity
$Account=(aws sts get-caller-identity | ConvertFrom-Json).Account
$RoleArn="arn:aws:iam::$($Account):role/LabRole"
aws lambda create-function --function-name hello3 --runtime python3.8 --handler hello_handler.hello_handler --zip-file fileb://hello_code.zip
aws lambda create-function --function-name hello3 --runtime python3.8 --handler hello_handler.hello_handler --zip-file fileb://hello_code.zip --role $RoleArn
aws lambda list-functions
cat hello_handler.py
cat payload.json
aws lambda invoke --function-name hello3 --payload fileb://payload.json out.txt
cat out.txt
ls
cd _capture
(Get-History).CommandLine 
