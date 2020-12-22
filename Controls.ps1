Add-Type -AssemblyName PresentationCore, PresentationFramework

class TB {
    [String] $Name
    [System.Windows.Controls.TextBox] $Component

    TB([string] $name) {
        $this.Name = $name
        $this.Component = [System.Windows.Controls.TextBox]::new()
        $this.Component.Name = $name
        $this.Component.Height = 40
        $this.Component.Width = 250
    }

    [string] GetResult(){
        $result = $this.Component.Text
        return $result
    }

    [void] LoadValues(){
        
    }
}

class CB {
    [String] $Name
    [System.Windows.Controls.ComboBox] $Component
    [ScriptBlock] $Script

    CB([string] $name, [ScriptBlock] $itemsScript) {
        $this.Name = $name
        $this.Script = $itemsScript

        $this.Component = [System.Windows.Controls.ComboBox]::new()
        $this.Component.Name = $name
        $this.Component.Height = 40
        $this.Component.Width = 250
    }

    [string] GetResult(){
        $result =  $this.Component.SelectedItem
        Write-Host $result.GetType()
        return $result
    }

    [void] LoadValues(){
        $items = $this.Script.Invoke()
        $items | ForEach-Object {Write-Host $_.GetType()}
        $this.Component.ItemsSource = $items
    }
}

function CreateButton([string] $name, [ScriptBlock] $clickHandler) {
    $button = [System.Windows.Controls.Button]::new()
    $button.Name = "Execute"
    $button.Content = "Execute"
    $button.Height = 40
    $button.Add_Click({$scriptBlock.Invoke()})
    return $button
}

function CreateLabeledWrapper([System.Windows.Controls.Control] $control) {
    Write-Host "Creating line wrapper for $control $($control.Name)"
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