function New-CwmProjectPhase {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmProjectPhase:"
    }

    PROCESS {
        $ReturnObject = [CwmProjectPhase]::new()
    }

    END {
        $ReturnObject
    }
}