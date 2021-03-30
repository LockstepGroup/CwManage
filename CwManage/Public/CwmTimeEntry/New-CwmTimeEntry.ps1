function New-CwmTimeEntry {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmTimeEntry:"
    }

    PROCESS {
        $ReturnObject = [CwmTimeEntry]::new()
    }

    END {
        $ReturnObject
    }
}
