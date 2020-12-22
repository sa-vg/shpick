$scriptBlock = {
    foreach ($item in $items) {
        $itemResult = $item.GetResult()
        Write-Host ($itemResult.GetType()) -ForegroundColor Yellow 
        $result.Add($item.Name, $item.GetResult())
    }
    
    WriteResult($result)
    $targetScript.Invoke()
}

function WriteResult([HashTable] $result) {
    Write-Host ($result | fl | out-string ) -ForegroundColor Green 
    Write-Host ($result.Values | ForEach-Object { $_.GetType() }) -ForegroundColor Green 
}

$window = [System.Windows.Window]::new()
$window.Height = 400
$window.Width = 400
$stack = [System.Windows.Controls.StackPanel]:: new()
$window.Content = $stack

foreach ($item in $items) {
    $itemLine = CreateLabeledWrapper($item.Component)
    $stack.AddChild($itemLine)
}

$executeButton = CreateButton("Execute", $scriptBlock)
$stack.AddChild($executeButton)

$markup = [System.Windows.Markup.XamlWriter]::Save($window)
$markup

foreach ($item in $items) {
    $item.LoadValues()
}

$window.ShowDialog() | Out-Null