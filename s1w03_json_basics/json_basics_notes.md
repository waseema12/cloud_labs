# JSON

## PowerShell

### File input

JSON can originate from any PowerShell cmdlet.
We often want to read JSON from a file.
In PowerShell we use `Get-Content` to return the contents of a file.xs

### Parsing JSON

When we read a JSON file into a PowerShell variable it is still just text.
We can use `ConvertFrom-Json` to turn this into a set of PowerShell objects. 

We can combine the reading (or other generation) and parsing operations using the pipe operator.

	Get-Content 'myfile.json' | ConvertFrom-Json

## jq / Bash

### Pretty-print file

## Python

## Java

## Csharp

