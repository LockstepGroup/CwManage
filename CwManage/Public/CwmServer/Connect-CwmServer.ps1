function Connect-CwmServer {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwmAuthString,

        [Parameter(Mandatory = $false)]
        [string]$ClientId = $global:CwmClientId
    )

    BEGIN {
        $VerbosePrefix = "Connect-CwmServer:"
    }

    PROCESS {
        $Params = @{}

        if ($AuthString) {
            $Params.AuthString = $AuthString
        }

        if ($ClientId) {
            $Params.ClientId = $ClientId
        }

        $ReturnObject = New-CwmServer @Params
        #TODO: need to add a test connection
    }

    END {
        $Global:CwmServer = $ReturnObject
    }
}
