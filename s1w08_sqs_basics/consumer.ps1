# demo SQS consumer script
# Peadar Grant

param (
	[Parameter(Mandatory)] $QUrl
	)

$max_wait = 1

while (1) {
    $msg_text = (aws sqs receive-message --queue-url $QUrl --wait-time-seconds $max_wait --max-number-of-messages 1)
    $max_wait = 20

    if ( $msg_text -eq $null) {
        Write-host "no messages" -ForegroundColor Blue
        continue
    }

    $msg = ($msg_text | ConvertFrom-Json).Messages[0]

    Write-Host "Received: " -NoNewline -ForegroundColor Green
    Write-Host $msg.Body
    aws sqs delete-message --queue-url $QUrl --receipt-handle $msg.ReceiptHandle
}