$DebugPreference = "Continue"



function Test-Cmdlet {
    [CmdletBinding()]
    param (
        [string] $Name,
        [int] $IntValue,
        [System.DateTime] $Date,
        [System.Diagnostics.Process] $Process,
        [switch] $Toggle
    )
    
    begin {
        Write-Host "[Begin] Name: $Name IntValue: $IntValue Date: $Date Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
    
    process {
        Write-Host "[Processing] Name: $Name IntValue: $IntValue Date: $Date Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
    
    end {
        Write-Host "[End] Name: $Name IntValue: $IntValue Date: $Date Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
}

Add-Type -Path ".\Shpick.Wpf\bin\Debug\Shpick.Wpf.dll"
Add-Type -Path ".\Shpick.Wpf\bin\Debug\Shpick.Models.dll"

$specs = @(
[Shpick.Models.CheckBoxSpec]::new("Toggle")
[Shpick.Models.TextBoxSpec]::new("Name")
[Shpick.Models.TextBoxSpec]::new("IntValue")
)

function Get-Parameters {
        
    param (
            [hashtable] $parameterProvider
    )
           
    $picker = [Shpick.Wpf.ParametersPicker]::new($specs)
    $script = { 
            param(
                    $picker
            )
  
            $picker.ShowWindow() | Out-Null
    }
                
    $ps = [PowerShell]::Create().
    AddScript($script).
    AddArgument($picker).
    AddArgument($cts)
           
    $runspace = [RunspaceFactory]::CreateRunspace()
    $runspace.ApartmentState = "STA"
    $runspace.ThreadOptions = "ReuseThread"
    $runspace.Open()
                    
    $ps.Runspace = $runspace
    $asyncResult = $ps.BeginInvoke() 

    start-sleep -seconds 1
    if ($ps.HadErrors) {
            $ps.Streams.Error | Out-String | Write-host
    }

    try {
            return $picker.GetParameters()
    }
    catch {
            $error | Out-String | Write-host
    }
}


Get-Parameters | % { Test-Cmdlet @_ }