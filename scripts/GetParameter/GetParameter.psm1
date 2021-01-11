Add-Type -Path ".\Shpick.Wpf.dll"
Add-Type -Path ".\Shpick.Models.dll"

#TODO: to cmdlets
function CheckBox()
{
    [OutputType([Shpick.Models.IParameterSpec])]
    param(
        [Parameter(Position = 1)]
        [string] $Name
    )
    return [Shpick.Models.CheckBoxSpec]@{ Name = $name }
}

function TextBox()
{
    [OutputType([Shpick.Models.IParameterSpec])]
    param(
        [Parameter(Position = 1)]
        [string] $Name
    )
    return [Shpick.Models.TextBoxSpec]@{ Name = $name }
}

function ComboBox()
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
        DisplayMemberPath = $DisplayMemberPath}
}

function Get-Parameter
{
    param (
        [Parameter(Position = 1)]
        [Shpick.Models.IParameterSpec[]] $Parameters
    )

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

    $runspace = [RunspaceFactory]::CreateRunspace()
    $runspace.ApartmentState = "STA"
    $runspace.ThreadOptions = "ReuseThread"
    $runspace.Open()

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
        }
        catch
        {
            $error | Out-String | Write-host
        }
    }
}