# Script to capture shell history in class
# Peadar Grant

$Folder = "_capture"

# Bail out if not in a "topic" folder
if( -not (Test-Path -Path ../save_history.ps1 -PathType Leaf)) {
	throw "not in a topic folder"
}

# Make folder if doesn't already exist
md -Force $Folder | Out-Null

# Generate output filename
$FormattedDate = Get-Date -format "yyyy-MM-dd-HHmm"
$OutFilename = "$Folder/history_$FormattedDate.ps1"

# Output to file
Write-Host "output to $OutFilename ... " -NoNewline
(Get-History).CommandLine | Out-File $OutFilename -Encoding ascii
Write-Host "done!" -ForegroundColor Green

# Add to git
git add $OutFilename

# Clear the history
Clear-History

