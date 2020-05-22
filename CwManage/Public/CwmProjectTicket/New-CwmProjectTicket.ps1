function New-CwmProjectTicket {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmProjectTicket:"
    }

    PROCESS {
        $ReturnObject = [CwmProjectTicket]::new()
    }

    END {
        $ReturnObject
    }
}