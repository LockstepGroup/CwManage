function New-CwmServer {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwmAuthString,

        [Parameter(Mandatory = $false)]
        [string]$ClientId = $global:CwmClientId
    )

    BEGIN {
        $VerbosePrefix = "New-CwmServer:"
    }

    PROCESS {
        $ReturnObject = [CwmServer]::new()

        if ($AuthString) {
            $ReturnObject.AuthString = $AuthString
        }

        if ($ClientId) {
            $ReturnObject.ClientId = $ClientId
        }
    }

    END {
        $ReturnObject
    }
}
