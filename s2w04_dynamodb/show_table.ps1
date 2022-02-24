# Loops through DynamoDB table in full

$TableName='message_table'

$Items = ( aws dynamodb scan --table-name $TableName | ConvertFrom-Json).Items

foreach ( $Item in $Items ) {

	Write-Host $Item.message.S -ForegroundColor Yellow -NoNewLine
	Write-Host " " -NoNewLine
	Write-Host $Item.subject.S
	
}