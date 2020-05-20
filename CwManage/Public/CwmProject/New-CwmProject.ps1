function New-CwmProject {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmProject:"
    }

    PROCESS {
        $ReturnObject = [CwmProject]::new()
    }

    END {
        $ReturnObject
    }
}