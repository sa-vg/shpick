function Test-Cmdlet {
    [CmdletBinding()]
    param (
        [string] $Name,
        [int] $IntValue,
        [System.DateTime] $Date,
        [System.Diagnostics.Process] $Process
    )
    
    begin {
        
    }
    
    process {

        Write-Host "Name: $Name IntValue: $IntValue Date: $Date Process $Process"
    }
    
    end {
        
    }
}


