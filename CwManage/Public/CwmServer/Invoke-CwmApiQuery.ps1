function Invoke-CwmApiQuery {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string]$UriPath,

        [Parameter(Mandatory = $false)]
        [hashtable]$QueryParameters = @{},

        [Parameter(Mandatory = $false)]
        [hashtable]$Conditions = @{},

        [Parameter(Mandatory = $false)]
        [string]$Method = 'GET'
    )

    BEGIN {
        $VerbosePrefix = "Invoke-CwmApiQuery:"
    }

    PROCESS {
        if (-not $Global:CwmServer) {
            Throw "$VerbosePrefix no active connection to ConnectWise Manage, please use Connect-CwmServer to get started."
        } else {
            $Global:CwmServer.UriPath = $UriPath
            $ReturnObject = $Global:CwmServer.invokeApiQuery($Conditions, $QueryParameters, $Method)
        }
    }

    END {
        $ReturnObject
    }
}