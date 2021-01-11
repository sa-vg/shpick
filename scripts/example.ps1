$DebugPreference = "Continue"
$ErrorActionPreference = "Stop"

. ./scripts/controls.ps1
. ./scripts/Test-Cmdlet.ps1

Get-Parameters @(
CheckBox "Toggle"
TextBox "Name"
TextBox "IntValue"
ComboBox "Date" -ItemsSource { Get-Date }
ComboBox "Process" -DisplayMemberPath "Name" -ItemsSource { Get-Process -Name *powershell* }
) | % { Test-Cmdlet @_ }