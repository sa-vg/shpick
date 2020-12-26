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
        
    }
    
    process {
        Write-Host "[Processing] Name: $Name IntValue: $IntValue Date: $Date Process $Process Toggle: $Toggle" -ForegroundColor Magenta
    }
    
    end {
        
    }
}


