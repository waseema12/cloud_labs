#!/usr/bin/env pwsh

$link = Get-Content learner_lab_link.txt -Raw
Start-Process $link

