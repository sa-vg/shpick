 function Test-Cmdlet {
    [CmdletBinding()]
    param (
        [string] $Name,
        [int] $IntValue,
        [System.Diagnostics.Process] $Process,
        [switch] $Toggle
    )
    
    begin {
        Write-Debug "TestCmdlet begin"
        Write-Host " $($Name.GetType()) $Name"
    }
    
    process {
        Write-Debug "TestCmdlet process"
        Write-Host "[Processing] Name: $Name IntValue: $IntValue Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
    
    end {
        Write-Debug "TestCmdlet end"
        Write-Host "[End] Name: $Name IntValue: $IntValue Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
}

# $testData1 = @{
#     Name = "TestName"
#     IntValue = "555"
#     Date = Get-Date
#     Toggle = $null
# }

# $testData2 = @{
#     Name = "TestName2"
#     IntValue = "444"
#     Date = Get-Date
#     Toggle = $true
# }

# @($testData1, $testData2, $testData1) | % { Test-Cmdlet @_}
