function New-CwmOpportunity {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmOpportunity:"
    }

    PROCESS {
        $ReturnObject = [CwmOpportunity]::new()
    }

    END {
        $ReturnObject
    }
}
