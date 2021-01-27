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
        [Parameter(Position = 2)]
        [ScriptBlock] $ItemsSource,
        [string] $DisplayMemberPath
    )

    $comboBox = [Shpick.Models.ComboBoxSpec]@{
        Name = $Name;
        ItemsSource = $ItemsSource.Invoke();
        DisplayMemberPath = $DisplayMemberPath
    }

    Write-Verbose ($comboBox | Out-String)
    return $comboBox
}

Set-Alias -Name checkBox -Value New-CheckBox
Set-Alias -Name textBox -Value New-TextBox
Set-Alias -Name comboBox -Value New-ComboBox

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

    begin{
        $pickedParameters = [Shpick.Models.ParameterStream]::new()

        $script = {
            param(
                [Shpick.Models.IParameterSpec[]] $specs,
                [Shpick.Models.ParameterStream] $stream
            )
            try
            {
                $picker = [Shpick.Wpf.ParametersPicker]::new($specs, $stream)
            }
            catch
            {
                $_ | Write-Error
                $stream.Close()
            }

        }

        $ps = [PowerShell]::Create().
                AddScript($script).
                AddArgument($Parameters).
                AddArgument($pickedParameters)

        $runspace = Open-WindowRunspace([void])
        $ps.Runspace = $runspace
        $asyncResult = $ps.BeginInvoke()

        # TODO: wait event
        Start-Sleep -Seconds 1

        if ($ps.HadErrors)
        {
            Write-Host "Failed to open window"
            $ps.Streams.Error | Write-Error
        }
    }

    process{
        try
        {
            foreach ($parameterSet in $pickedParameters)
            {
                Write-Verbose ($parameterSet | Out-String)
                Write-Output $parameterSet
            }
            Write-Host "Window closed"
        }
        catch
        {
            $_ | Write-Error
        }
    }

    end{
        Write-Debug "End processing"
        $ps.Dispose()
    }
}