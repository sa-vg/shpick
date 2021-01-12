$moduleName = "GetParameter" 
$psModulePath = $env:PsModulePath -split ';' | select -First 1
$source = "$PSScriptRoot\$moduleName"

Write-Host "Copying [$source] to [$psModulePath] ..."
copy $source $psModulePath -Recurse -Force
Write-Host "Done ..."