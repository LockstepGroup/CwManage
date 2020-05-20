function Get-CwmTimeEntry {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$AgreementId,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmTimeEntry:"

        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        $Conditions = @{}

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

        foreach ($r in $Response) {
            $ThisObject = New-CwmTimeEntry
            $ThisObject.FullData = $r

            $ThisObject.CompanyName = $r.company.name
            $ThisObject.Member = $r.member.name
            $ThisObject.Notes = $r.notes
            $ThisObject.ActualHours = $r.actualHours
            $ThisObject.TicketSummary = $r.ticket.summary

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}