cd Desktop
cd cloud_labs
ls
./learner_lab.ps1
./paste_credentials.ps1
./lab_checks.ps1
cd s2w03*
ls
git pull
Compress-Archive -Path hello_handler.py -DestinationPath hello_code.zip
Compress-Archive -Path hello_handler.py -DestinationPath hello_code.zip -Force
$Account = (aws sts get-caller-identity | ConvertFrom-Json).Account
$Account
$RoleArn="arn:aws:iam::$($Account):role/LabRole"
aws lambda create-function --function-name hello4 --runtime python3.8 --role $RoleArn --handler hello_handler.hello_handler --zip-file fileb://hello_code.zip
aws lambda create-function --function-name hello5 --runtime python3.8 --role $RoleArn --handler hello_handler.hello_handler --zip-file fileb://hello_code.zip
aws lambda invoke --function-name hello5 --payload fileb://payload.json out.txt
cat out.txt
