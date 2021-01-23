$DebugPreference = "Continue"
$ErrorActionPreference = "Stop"

Import-Module $PSScriptRoot/GetParameter.psm1
Import-Module $PSScriptRoot/Test-Cmdlet.ps1

Get-Parameter @(
New-CheckBox "Toggle"
New-TextBox "Name"
New-TextBox "IntValue"
New-ComboBox "Process" -DisplayMemberPath "Name" -ItemsSource { Get-Process -Name *powershell* }
) | foreach { Test-Cmdlet @_ }