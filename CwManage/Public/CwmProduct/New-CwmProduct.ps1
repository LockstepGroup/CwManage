function New-CwmProduct {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmProduct:"
    }

    PROCESS {
        $ReturnObject = [CwmProduct]::new()
    }

    END {
        $ReturnObject
    }
}
