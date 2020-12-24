using namespace System.Windows.Control

Add-Type -AssemblyName PresentationCore, PresentationFramework

. ./Controls.ps1
. ./Test-Cmdlet.ps1

$DebugPreference = "Continue"

$controls = @(
    [PsComboBox]::new("Date", { Get-Date })
    [PsComboBox]::new("Process", { Get-Process -Name *powershell* })
    [PsTextBox]::new("Name")
    [PsTextBox]::new("IntValue")
)

[PsButton[]] $buttons = @( [PsButton]::new("Execute", { param($p) Test-Cmdlet @p })
) 

$main = [WindowHolder]::new($controls, $buttons)
$main.Window.ShowDialog() | Out-Null


