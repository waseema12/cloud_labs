clear
cd ~/Desktop
ls
cd cloud_labs
ls
git pull
cd s2w03*
ls
python3
python3
../learner_lab.ps1
cd ..
ls
.\learner_lab.ps1
Compress-Archive -Paths hello_handler.py -DestinationPath hello_code.zip
Compress-Archive -Path hello_handler.py -DestinationPath hello_code.zip
cd s2w03*
Compress-Archive -Path hello_handler.py -DestinationPath hello_code.zip
ls
../paste_credentials.ps1
../lab_checks.ps1
[default]
aws_access_key_id=ASIAVRR3P3RFJXIX6QI2
aws_secret_access_key=d8R3NrkhGL9e0gCFIPcramb+ofHaSpFvjK3cif7P
aws_session_token=FwoGZXIvYXdzEG4aDDx2dmXqk57OZCu53SK9AYOPGkYpu+RhCtOrZDe0ju/VF7z26giqHFitCK4b4eWZQisQpBDUWrXzUu3stTC5nxKg9Rx/VNEafghs3wygObjd0I2Sj2P3zA9/ukLqPB5N+WPBwPpyAD0P7WFAdBbfVIEU5xmPOlwV/tNIldym0R3U03QTE/ed17ntNdZyqthGEnjxX3Mg2CNLBTN7EQXNSESbD/6dvyF/rLmvDnuqRBIeWfJiYFaolg1tK+s1uvDLhwuY0Y489075/zdpQSiPu66QBjIt9Po0P4P7Eqm9fladksrOTMPLYHBzVqkQSGn0KcvpDYToTWGOPvts65uECzT8
aws iam get-caller-identity
aws iam get-account-summary
aws sts get-caller-identity
$AccountId=(aws sts get-caller-identity | ConvertFrom-Json).Account
$AccountId
$LabRoleArn="arn:aws:iam::$AccountId:role/LabRole"
$LabRoleArn
$LabRoleArn="arn:aws:iam::$($AccountId):role/LabRole"
$LabRoleArn
aws lambda create-function --function-name hello --zip-file fileb://hello_code.zip --handler hello_handler.hello_handler --runtime python3.8 --role $LabRoleArn
aws lambda create-function --function-name hello2 --zip-file fileb://hello_code.zip --handler hello_handler.hello_handler --runtime python3.8 --role $LabRoleArn
aws lambda invoke --function-name hello2
aws lambda invoke --function-name hello2 out.txt
Compress-Archive -Force -Paths hello_handler.py -DestinationPath hello_code.zip
Compress-Archive -Force -Path hello_handler.py -DestinationPath hello_code.zip
aws lambda update-function-code --function-name hello2 --zip-file fileb://hello_code.zip
aws lambda invoke --function-name hello2 --payload fileb://payload.json out.txt
Compress-Archive -Force -Path hello_handler.py -DestinationPath hello_code.zip
aws lambda update-function-code --function-name hello2 --zip-file fileb://hello_code.zip
aws lambda invoke --function-name hello2 --payload fileb://payload.json out.txt
git status
git add *.md
git add hello_handler.py
mkdir _capture
cd _capture
ls
