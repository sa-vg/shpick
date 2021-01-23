Add-Type -Path "$PSScriptRoot\Shpick.Wpf.dll"
Add-Type -Path "$PSScriptRoot\Shpick.Models.dll"

#TODO: to cmdlets
function New-CheckBox()
{
    [OutputType([Shpick.Models.IParameterSpec])]
    param(
        [Parameter(Position = 1, ValueFromPipeline)]
        [string] $Name
    )
    return [Shpick.Models.CheckBoxSpec]@{ Name = $name }
}

function New-TextBox()
{
    [OutputType([Shpick.Models.IParameterSpec])]
    param(
        [Parameter(Position = 1, ValueFromPipeline)]
        [string] $Name
    )
    return [Shpick.Models.TextBoxSpec]@{ Name = $name }
}

function New-ComboBox()
{
    [OutputType([Shpick.Models.IParameterSpec])]
    param(
        [Parameter(Position = 1, ValueFromPipeline)]
        [string] $Name,
        [string] $DisplayMemberPath,
        [ScriptBlock] $ItemsSource
    )

    return [Shpick.Models.ComboBoxSpec]@{
        Name = $Name;
        ItemsSource = $ItemsSource.Invoke();
        DisplayMemberPath = $DisplayMemberPath
    }
}

function Open-WindowRunspace()
{
    $runspace = [RunspaceFactory]::CreateRunspace()
    $runspace.ApartmentState = "STA"
    $runspace.ThreadOptions = "ReuseThread"
    $runspace.Open()
    return $runspace
}

function Get-Parameter
{
    [CmdletBinding()]
    param (
        [Parameter(Position = 1)]
        [Shpick.Models.IParameterSpec[]] $Parameters
    )

    process{
        $pickedParameters = [Shpick.Models.ParameterStream]::new()

        $script = {
            param(
                $specs,
                $stream
            )
            $picker = [Shpick.Wpf.ParametersPicker]::new($specs, $stream)
        }

        $ps = [PowerShell]::Create().
                AddScript($script).
                AddArgument($Parameters).
                AddArgument($pickedParameters)

        $runspace = Open-WindowRunspace([void])
        $ps.Runspace = $runspace
        $asyncResult = $ps.BeginInvoke()

        start-sleep -seconds 1
        if ($ps.HadErrors)
        {
            $ps.Streams.Error | Out-String | Write-host
        }
        else
        {
            try
            {
                return $pickedParameters
                Write-Host "Window closed"
            }
            catch
            {
                $error | Out-String | Write-host
                $ps.Dispose()
            }
        }
    }
    
}