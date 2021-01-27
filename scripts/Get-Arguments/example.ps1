Import-Module $PSScriptRoot/Get-Arguments.psm1
Import-Module $PSScriptRoot/Test-Cmdlet.ps1

#$DebugPreference = "Continue"
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

Get-Arguments -Verbose @(
checkBox Toggle
textBox Name
textBox IntValue
comboBox Process { Get-Process -Name *powershell* } -DisplayMemberPath "Name" 
) | foreach { Test-Cmdlet @_ }