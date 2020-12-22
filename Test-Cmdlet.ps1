function Test-Cmdlet {
    [CmdletBinding()]
    param (
        [string] $Name,
        [int] $IntValue,
        [System.DateTime] $Date
    )
    
    begin {
        
    }
    
    process {

        Write-Host "Name: $Name IntValue: $IntValue Date: $Date"
    }
    
    end {
        
    }
}

$parameters = Test-Cmdlet | Get-Command 

$p = @{}
Test-Cmdlet @p

