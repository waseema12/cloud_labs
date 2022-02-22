../save_history.ps1
cd ..
mkdir s2w04_dynamodb
cd s2w04*
ls
aws dynamodb 
aws dynamodb  help
aws dynamodb list-tables
aws dynamodb scan 
aws dynamodb scan --table-name lecturetable
$Items = ( aws dynamodb scan --table-name lecturetable | ConvertFrom-Json).Items 
$Items
$Items[0]
$Items[1]
$Items[1].description 
$Items[1].description.S
