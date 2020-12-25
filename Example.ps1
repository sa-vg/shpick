using namespace System.Windows.Control

Add-Type -AssemblyName PresentationCore, PresentationFramework

. ./Controls.ps1
. ./Test-Cmdlet.ps1

$DebugPreference = "Continue"

[PsWindow]::new().
AddComboBox("Date", { Get-Date }).
AddComboBox("Process", { Get-Process -Name *powershell* }).
AddTextBox("Name").
AddTextBox("IntValue").
AddButton("Execute", { param($p) Test-Cmdlet @p }).
ShowDialog()


