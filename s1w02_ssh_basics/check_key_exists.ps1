
$files = @( "$HOME/.ssh/id_rsa", "$HOME/.ssh/id_rsa.pub" )

foreach ( $file in $files ) {

	if ( Test-Path -Path $file ) {
	   Write-Host "$file ... exists"
	}
	else {
	   Write-Host "$file ... does not exist!"
	   Write-Host "fix and re-run check script"
	   Return
	}

}

Write-Host "your SSH keys appear to be set up correctly!