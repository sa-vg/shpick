using namespace System.Windows.Control

Add-Type -AssemblyName PresentationCore, PresentationFramework

. ./Controls.ps1
. ./Test-Cmdlet.ps1

$DebugPreference = "Continue"

# Show-Gui -Item @([PsComboBox]::new("Date", { Get-Date }), [PsComboBox]::new("Process", { Get-Process -Name *powershell* })) -Button @([PsButton]::new("Execute", { param($p) Test-Cmdlet @p }))

function Show-Gui {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PsItem[]] $ComboBox,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [PsButton[]] $Button
    )
    
   $window = [WindowHolder]::new($Item, $Button)
   $window.Window.ShowDialog() | Out-Null
}



