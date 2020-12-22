using namespace System.Windows.Control
 
Add-Type -AssemblyName PresentationCore, PresentationFramework

. ./Classes.ps1
. ./Test-Cmdlet.ps1

$items = @(
    [CB]::new("Date", { Get-Date })
    [TB]::new("Name")
    [TB]::new("IntValue")
)
$result = @{}
$targetScript = { Test-Cmdlet @result}

& ./ShowWindow.ps1