using namespace System.Windows.Control
Add-Type -AssemblyName PresentationCore, PresentationFramework

. ./Controls.ps1
. ./Test-Cmdlet.ps1

#$DebugPreference = "Continue"
#$DebugPreference = "SilentlyContinue"

[PsWindow]::new().
ComboBox("Date", { Get-Date }).
ComboBox("Process",  { Get-Process -Name *powershell* }, "Name").
TextBox("Name").
TextBox("IntValue").
CheckBox("Toggle").
Button("Execute", { param($p) Test-Cmdlet @p }).
ShowDialog() | Write-Host | Test-Cmdlet


