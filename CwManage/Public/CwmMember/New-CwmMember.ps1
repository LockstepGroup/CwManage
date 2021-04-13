function New-CwmMember {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmMember:"
    }

    PROCESS {
        $ReturnObject = [CwmMember]::new()
    }

    END {
        $ReturnObject
    }
}
