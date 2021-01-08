using namespace System.Windows.Control
Add-Type -AssemblyName PresentationCore, PresentationFramework

. ./Controls.ps1
. ./Test-Cmdlet.ps1
. ./ParametersPicker.ps1

$DebugPreference = "Continue"
function Get-Parameters {
        
        param (
                [hashtable] $parameterProvider
        )
        
        $rawParameters = $parameterProvider
           
        $requestQueue = [System.Collections.Concurrent.BlockingCollection[Hashtable]]::new()
        $cts = [System.Threading.CancellationTokenSource]::new()
        $cancellationToken = $cts.Token

        $script = { 
                param(
                        $requestQueue,
                        $cts
                )
                        
                Add-Type -AssemblyName PresentationCore, PresentationFramework
                . ./Controls.ps1
                . ./ParametersPicker.ps1
                $DebugPreference = "Continue"
            
                [ParameterPickerWindow]::new(600, 400, $requestQueue, $cts).
                ComboBox("Date", { Get-Date }).
                ComboBox("Process", { Get-Process -Name *powershell* }, "Name").
                TextBox("Name").
                TextBox("IntValue").
                CheckBox("Toggle").
                ShowDialog() | Out-Null

                $cts.Cancel()
                $requestQueue.Dispose()
        }
                    
        $ps = [PowerShell]::Create().
        AddScript($script).
        AddArgument($requestQueue).
        AddArgument($cts)
               
        $runspace = [RunspaceFactory]::CreateRunspace()
        $runspace.ApartmentState = "STA"
        $runspace.ThreadOptions = "ReuseThread"
        $runspace.Open()
                        
        $ps.Runspace = $runspace
        $asyncResult = $ps.BeginInvoke() 

        start-sleep -seconds 1
        if ($ps.HadErrors) {
                $ps.Streams.Error | Out-String 
        }

        try {
                return $requestQueue.GetConsumingEnumerable($cancellationToken)
        }
        catch {
                $error | Out-String | Write-host
        }
                

        
}


Get-Parameters | % { Test-Cmdlet @_ }

