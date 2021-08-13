function New-CwmContact {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmContact:"
    }

    PROCESS {
        $ReturnObject = [CwmContact]::new()
    }

    END {
        $ReturnObject
    }
}
