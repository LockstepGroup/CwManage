function New-CwmCompany {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmCompany:"
    }

    PROCESS {
        $ReturnObject = [CwmCompany]::new()
    }

    END {
        $ReturnObject
    }
}
