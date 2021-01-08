using namespace System.Windows.Controls
Add-Type -AssemblyName PresentationCore, PresentationFramework

class ParameterPickerWindow {
    [System.Windows.Window] $Window
    [System.Windows.Controls.StackPanel] $ItemsContainer
    [PsItem[]] $Items = @()
    [System.Collections.Concurrent.BlockingCollection[Hashtable]] $Requests 
    [System.Threading.CancellationTokenSource] $RequestsLifetime
  

    ParameterPickerWindow(
        [int] $width = 600,
        [int] $height = 400,
        [System.Collections.Concurrent.BlockingCollection[Hashtable]] $requests,
        [System.Threading.CancellationTokenSource] $cts) 
    {
        $this.Window = [System.Windows.Window]::new()
        $this.Window.Height = $height
        $this.Window.Width = $width
        $this.ItemsContainer = [System.Windows.Controls.StackPanel]:: new()
        $this.Window.Content = $this.ItemsContainer
        $this.Requests = $requests
        $this.RequestsLifetime = $cts
        
    }


    [ParameterPickerWindow] TextBox([string] $name) {
        $item = [PsTextBox]::new($name)
        $itemLine = WrapLine($item.Component)
        $this.ItemsContainer.AddChild($itemLine)
        $this.Items += $item;
        return $this
    }
    
    [ParameterPickerWindow] CheckBox([string] $name) {
        $item = [PsCheckBox]::new($name)
        $itemLine = WrapLine($item.Component)
        $this.ItemsContainer.AddChild($itemLine)
        $this.Items += $item;
        return $this
    }

    [ParameterPickerWindow] ComboBox([string] $name, [ScriptBlock] $script) {
        return $this.ComboBox($name, $script, $null)
    }

    [ParameterPickerWindow] ComboBox([string] $name, [ScriptBlock] $script, [string] $displayMember) {
        $item = [PsComboBox]::new($name, $script, $displayMember)
        $itemLine = WrapLine($item.Component)
        $this.ItemsContainer.AddChild($itemLine)
        $this.Items += $item;
        return $this
    }
    
    hidden [void] CreateExecuteButton() {
        $button = [System.Windows.Controls.Button]::new()
        $button.Name = "Execute"
        $button.Content = "Execute"
        $button.Height = 30
        $this.ItemsContainer.AddChild($button)
        $button.Add_Click($this.OnButtonClick)
    }

    [void] ShowDialog() {
    
        $this.CreateExecuteButton()
        Dump("Opening window in another thread.")
        $this.Window.ShowDialog() 
    }

    [void] OnWindowClose([object] $s, [object] $a) {
        Dump("Window close event received.")
        $this.Requests.CompleteAdding()
        $this.Requests.Dispose()
        $this.RequestsLifetime.Cancel()
    }

    hidden [Hashtable] GetResult() {
        Dump("Collecting constructed parameters...")
        $result = @{}

        foreach ($item in $this.Items) {
            $result.Add($item.Name, $item.GetResult())       
        }
        
        Dump("Parameters:")
        Dump(( $result | Out-String ))
        
        return $result
    }
    
    hidden [void] OnButtonClick([object] $s, [object] $a) {
        Dump("Button click event received.")
        $pickedParameters = $this.GetResult()
        $this.Requests.Add($pickedParameters)
    }


}

