$DebugPreference = "Continue"
$ErrorActionPreference = "Stop"

Import-Module ./GetParameter.psm1
Import-Module ./Test-Cmdlet.ps1

Get-Parameter @(
CheckBox "Toggle"
TextBox "Name"
TextBox "IntValue"
#ComboBox "Date" -ItemsSource { Get-Date }
ComboBox "Process" -DisplayMemberPath "Name" -ItemsSource { Get-Process -Name *powershell* }
) | % { Test-Cmdlet @_ }