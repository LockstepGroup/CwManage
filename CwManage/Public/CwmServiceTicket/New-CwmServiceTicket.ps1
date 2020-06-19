function New-CwmServiceTicket {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmServiceTicket:"
    }

    PROCESS {
        $ReturnObject = [CwmServiceTicket]::new()
    }

    END {
        $ReturnObject
    }
}
