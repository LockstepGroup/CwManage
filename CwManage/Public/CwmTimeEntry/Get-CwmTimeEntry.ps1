function Get-CwmTimeEntry {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$AgreementId,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmTimeEntry:"

        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        if ($AgreementId) {
            $Conditions.'agreement/id' = $AgreementId
        }

        $ApiParams = @{}
        $ApiParams.UriPath = 'time/entries'
        $ApiParams.Conditions = $Conditions
        $ApiParams.QueryParameters = @{}
        $ApiParams.QueryParameters.page = 1
        $ApiParams.QueryParameters.pageSize = $PageSize

        $Response = Invoke-CwmApiQuery @ApiParams

        if ($ShowAll) {
            if ($Response.Count -eq $PageSize) {
                $ApiParams.QueryParameters.page++
                $MoreValues = Invoke-CwmApiQuery @ApiParams
                $Response += $MoreValues
            }
        }

        foreach ($r in $Response) {
            $ThisObject = New-CwmTimeEntry
            $ThisObject.FullData = $r

            $ThisObject.CompanyName = $r.company.name
            $ThisObject.Member = $r.member.identifier
            $ThisObject.Notes = $r.notes
            $ThisObject.ActualHours = $r.actualHours
            $ThisObject.TicketSummary = $r.ticket.summary
            $ThisObject.TimeStart = $r.timeStart

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}