
using namespace System.Windows.Control
Add-Type -AssemblyName PresentationCore, PresentationFramework


function Dump([object] $obj) {
    Write-Debug "$obj"
}
function Dump([object] $obj, [string] $message) {
    Write-Debug "$message : $obj"
}

function Dump([object[]] $objects) {
    foreach ($obj in $objects) {
        Write-Debug "$obj [$($obj.GetType())]"
    }
}

class PsItem {

}

class PsTextBox: PsItem {
    [String] $Name
    [System.Windows.Controls.TextBox] $Component

    PsTextBox([string] $name) {
        $this.Name = $name
        $this.Component = [System.Windows.Controls.TextBox]::new()
        $this.Component.Name = $name
        $this.Component.Height = 30
        $this.Component.Width = 250
    }

    [object] GetResult() {
        $result = $this.Component.Text
        Dump($result)
        return $result
    }
}

class PsCheckBox: PsItem {
    [String] $Name
    [System.Windows.Controls.CheckBox] $Component

    PsCheckBox([string] $name) {
        $this.Name = $name
        $this.Component = [System.Windows.Controls.CheckBox]::new()
        $this.Component.Name = $name
        $this.Component.Height = 30
        $this.Component.Width = 250
    }

    [object] GetResult() {
        $result = $this.Component.IsChecked
        Dump($result)
        return $result
    }
}

class PsComboBox: PsItem {
    [String] $Name
    [System.Windows.Controls.ComboBox] $Component
    [ScriptBlock] $Script

    PsComboBox([string] $name, [ScriptBlock] $itemsScript, [string] $displayMember) {
        $this.Name = $name
        $this.Script = $itemsScript

        $this.Component = [System.Windows.Controls.ComboBox]::new()
        $this.Component.Name = $name
        $this.Component.Height = 30
        $this.Component.Width = 250

        $items = $this.Script.Invoke()
        Write-Host "Loading values for $($this.Name)"
        Write-Host $items
        $this.Component.ItemsSource = $items

        if ($displayMember) {
            $this.Component.DisplayMemberPath = $displayMember
        }      
    }

    [object] GetResult() {
        $result = $this.Component.SelectedItem
        Dump($result)
        return $result
    }
}

class PsButton: PsItem {
    [String] $Name
    [System.Windows.Controls.Button] $Component

    PsButton([string] $name) {
        Dump("Creating button $name")
        
        $this.Name = $name

        $this.Component = [System.Windows.Controls.Button]::new()
        $this.Component.Name = "Execute"
        $this.Component.Content = "Execute"
        $this.Component.Height = 30
    }
}

function WrapLine([System.Windows.Controls.Control] $control) {
    Dump("Creating line wrapper for $control $($control.Name)")
    $line = [System.Windows.Controls.StackPanel]::new()
    $line.Orientation = [System.Windows.Controls.Orientation]::Horizontal

    $label = [System.Windows.Controls.Label]::new()
    $label.Content = $control.Name
    $label.Height = $control.Height
    $label.Width = 150
    $line.AddChild($label)
    $line.AddChild($control)
    return $line
}

class PsWindow {

    [System.Windows.Window] $Window
    [System.Windows.Controls.StackPanel] $ItemsContainer
    [PsItem[]] $Items = @()

    PsWindow() {
        $this.Window = [System.Windows.Window]::new()
        $this.Window.Height = 400
        $this.Window.Width = 600
        $this.ItemsContainer = [System.Windows.Controls.StackPanel]:: new()
        $this.Window.Content = $this.ItemsContainer
    }

    [PsWindow] TextBox([string] $name) {
        $item = [PsTextBox]::new($name)
        $itemLine = WrapLine($item.Component)
        $this.ItemsContainer.AddChild($itemLine)
        $this.Items += $item;
        return $this
    }
    
    [PsWindow] CheckBox([string] $name) {
        $item = [PsCheckBox]::new($name)
        $itemLine = WrapLine($item.Component)
        $this.ItemsContainer.AddChild($itemLine)
        $this.Items += $item;
        return $this
    }

    [PsWindow] ComboBox([string] $name, [ScriptBlock] $script) {
        return $this.ComboBox($name, $script, $null)
    }

    [PsWindow] ComboBox([string] $name, [ScriptBlock] $script, [string] $displayMember) {
        $item = [PsComboBox]::new($name, $script, $displayMember)
        $itemLine = WrapLine($item.Component)
        $this.ItemsContainer.AddChild($itemLine)
        $this.Items += $item;
        return $this
    }
    
    [PsWindow] AddExecuteButton() {
        $button = [PsButton]::new("Execute")
        
        $this.ItemsContainer.AddChild($button.Component)
        $handler = $this.CreateClickHandler($button)
        $button.Component.Add_Click({Write-Output "Shittttt"})
        $button.Component.Add_Click($handler)
        return $this
    }

    [void] ShowDialog() {
        $this.AddExecuteButton()
        $this.Window.ShowDialog()
    }

    [void] StartPipeline() {
        $this.AddExecuteButton()

        $this.Window.Show()
        
        while($true){
        Write-Output "lalala"
        Start-Sleep 1000
        }

    }

    [void] PrintMarkup() {
        Write-Host "XAML Markup:"
        $markup = [System.Windows.Markup.XamlWriter]::Save($this.Window)
        Write-Host $markup
    }

    hidden [Hashtable] GetResult() {
        Dump("Collecting constructed parameters...")
        $result = @{}
        foreach ($item in $this.Items) {
            $itemResult = $item.GetResult()
            $result.Add($item.Name, $itemResult)       
        }
        return $result
    }

    hidden [object] CreateClickHandler([PsButton] $button) {
        
        $w = $this
        $b = $button

        $handler = {
            Dump("Invoking hanler for [$($b.Name)], Handler: {$($b.Script)}")
            $pickedParameters = $w.GetResult()
            Dump("Parameters:")
            Dump(( $pickedParameters | Out-String ))

            Write-Output $pickedParameters
            #$PSCmdlet.WriteObject($pickedParameters)
        }.GetNewClosure()

        return $handler
    }
}

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
        Write-Host "[begin] Name: $Name IntValue: $IntValue Date: $Date Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
    
    process {
        Write-Host "[Processing] Name: $Name IntValue: $IntValue Date: $Date Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
    
    end {
        Write-Host "[end] Name: $Name IntValue: $IntValue Date: $Date Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
}

$DebugPreference = "Continue"
#$DebugPreference = "SilentlyContinue"

[PsWindow]::new().
ComboBox("Date", { Get-Date }).
ComboBox("Process",  { Get-Process -Name *powershell* }, "Name").
TextBox("Name").
TextBox("IntValue").
CheckBox("Toggle").
StartPipeline() | Write-Host | Test-Cmdlet  
#| % { Test-Cmdlet @_ }
