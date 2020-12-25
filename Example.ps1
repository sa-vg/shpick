using namespace System.Windows.Control
Add-Type -AssemblyName PresentationCore, PresentationFramework

. ./Controls.ps1
. ./Test-Cmdlet.ps1

$DebugPreference = "Continue"

[PsWindow]::new().
ComboBox("Date", { Get-Date }).
ComboBox("Process", { Get-Process -Name *powershell* }).
TextBox("Name").
TextBox("IntValue").
Button("Execute", { param($p) Test-Cmdlet @p }).
ShowDialog()


