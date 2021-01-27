Import-Module $PSScriptRoot/GetParameter.psm1
Import-Module $PSScriptRoot/Test-Cmdlet.ps1

#$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

Get-Parameter -Verbose @(
checkBox Toggle
textBox Name
textBox IntValue
comboBox Process { Get-Process -Name *powershell* } -DisplayMemberPath "Name" 
) | foreach { Test-Cmdlet @_ }