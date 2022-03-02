cd ~/Desktop/cloud_labs
git pull
./learner_lab.ps1
./paste_credentials.ps1
./lab_checks.ps1
cd s2w05*
ls
aws cloudformation help
ls
aws cloudformation validate-stack 
aws cloudformation validate-template
aws cloudformation validate-template --template-body file://s3_buckets_template.json
aws cloudformation validate-template --template-body file://s3_buckets_template.json
aws cloudformation create-stack --template-body file file://s3_buckets_template.json
aws cloudformation create-stack --template-body file file://s3_buckets_template.json --stack-name buckets1
aws cloudformation create-stack --template-body file://s3_buckets_template.json --stack-name buckets1
aws cloudformation list-stacks
aws cloudformation list-stacks
aws cloudformation 
aws cloudformation  help
aws cloudformation describe-stacks --stack-name buckets1
aws s3api list-buckets
aws cloudformation delete-stack --stack-name buckets1
aws s3api list-buckets
aws cloudformation list-stacks
aws cloudformation describe-stacks --stack-name buckets1#
aws cloudformation describe-stacks --stack-name buckets1
foreach ( $stack in @("b1","b2") ) { aws cloudformation create-stack --template-body file://s3_buckets_template.json --stack-name $stack }
aws cloudformation describe-stacks 
aws s3api list-buckets
aws cloudformation update-stack
aws cloudformation update-stack help
aws cloudformation update-stack --stack-name b1 --template-body file://s3_buckets_template.jsson
aws cloudformation update-stack --stack-name b1 --template-body file://s3_buckets_template.json
aws s3api list-buckets
aws cloudformation update-stack --stack-name b1 --template-body file://s3_buckets_template.json
aws s3api list-buckets
aws s3api list-buckets
aws s3api list-buckets
git status
git add s3_buckets_template.json
