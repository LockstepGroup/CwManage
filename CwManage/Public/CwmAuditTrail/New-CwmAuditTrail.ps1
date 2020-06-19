function New-CwmAuditTrail {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmAuditTrail:"
    }

    PROCESS {
        $ReturnObject = [CwmAuditTrail]::new()
    }

    END {
        $ReturnObject
    }
}