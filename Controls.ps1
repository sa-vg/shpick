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
    [ScriptBlock] $Script

    PsButton([string] $name, [ScriptBlock] $script) {
        Dump("Creating button $name")
        
        $this.Name = $name
        $this.Script = $script

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

    [System.Collections.Concurrent.BlockingCollection[Hashtable]] $Requests = [System.Collections.Concurrent.BlockingCollection[Hashtable]]::new()
    [System.Threading.CancellationTokenSource] $RequestsLifetime = [System.Threading.CancellationTokenSource]:: new()
    [PsItem[]] $Items = @()
    [PsButton[]] $Buttons = @()

    PsWindow() {
        $this.Window = [System.Windows.Window]::new()
        $this.Window.Height = 400
        $this.Window.Width = 600
        $this.ItemsContainer = [System.Windows.Controls.StackPanel]:: new()
        $this.Window.Content = $this.ItemsContainer
        $this.Window.Add_Closing($this.OnWindowClose)
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
    
    [PsWindow] Button([string] $name, [ScriptBlock] $script) {
        $button = [PsButton]::new($name, $script)
        $this.CreateClickHandler($button)
        $this.ItemsContainer.AddChild($button.Component)
        $this.Buttons += $button;
        return $this
    }

    [void] ShowDialog() {
        $this.Window.ShowDialog() | Out-Null
    }

    [System.Collections.IEnumerable] GetOutput() {
    
        $guiThread = Start-ThreadJob -ScriptBlock {
            Dump("Opening window in another thread.")
            $this.Window.ShowDialog() 
        }

        return $this.Requests.GetConsumingEnumerable($this.RequestsLifetime.Token)
    }

    [void] OnWindowClose([object] $s, [object] $a) {
        Dump("Window close event received.")
        $this.RequestsLifetime.Cancel()
        $this.Requests.Dispose()
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
        
        Dump("Parameters:")
        Dump(( $result | Out-String ))
        
        return $result
    }
    
    hidden [void] HandleClickToPipeline() {
        Dump("Invoking hanler for pipeline.")
        $pickedParameters = $this.GetResult()
        $this.Requests.Add($pickedParameters)
        # Write-Output $pickedParameters -NoEnumerate
    }

    hidden [void] CreateClickHandler([PsButton] $button) {
        
        $w = $this
        $b = $button

        $handler = {
            Dump("Invoking hanler for [$($b.Name)], Handler: {$($b.Script)}")
            $pickedParameters = $w.GetResult()
            $b.Script.Invoke($pickedParameters)
        }.GetNewClosure()

        $button.Component.Add_Click($handler)
    }
}
