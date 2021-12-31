function Get-CwmServiceTicket {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string]$ServiceBoard,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions,

        [Parameter(Mandatory = $False)]
        [hashtable]$QueryParameters,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000
    )
    BEGIN {
        $VerbosePrefix = "Get-CwmServiceTicket:"

        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        if ($ServiceBoard) {
            $Conditions.'board/name' = $ServiceBoard
        }

        if (-not $ShowAll) {
            $Conditions.'closedFlag' = $false
        }

        if ($ServiceBoard) {
            $Conditions.'board/name' = $ServiceBoard
        }

        $ApiParams = @{}

        if ($QueryParameters) {
            $ApiParams.QueryParameters = $QueryParameters
        } else {
            $ApiParams.QueryParameters = @{}
        }

        $ApiParams.UriPath = 'service/tickets'
        $ApiParams.Conditions = $Conditions
        $ApiParams.QueryParameters.page = 1
        $ApiParams.QueryParameters.pageSize = $PageSize

        $Response = Invoke-CwmApiQuery @ApiParams

        foreach ($r in $Response) {
            $ThisObject = New-CwmServiceTicket
            $ThisObject.FullData = $r

            $ThisObject.Id = $r.id
            $ThisObject.CompanyName = $r.company.name
            $ThisObject.Summary = $r.summary

            $ThisObject.AgreementId = $r.agreement.id
            $ThisObject.AgreementName = $r.agreement.name

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}