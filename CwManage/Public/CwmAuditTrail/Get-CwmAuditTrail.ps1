function Get-CwmAuditTrail {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmAuditTrail:"

        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        $Conditions = @{}

        if ($AgreementId) {
            $Conditions.'agreement/id' = $AgreementId
        }

        $Conditions.getRequest = '{"type":"agreement","id":55,"deviceIdentifier":"string"}'

        $ApiParams = @{}
        $ApiParams.UriPath = '/system/audittrail'
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
            $ThisObject = New-CwmAuditTrail
            $ThisObject.FullData = $r

            <# $ThisObject.CompanyName = $r.company.name
            $ThisObject.Member = $r.member.name
            $ThisObject.Notes = $r.notes
            $ThisObject.ActualHours = $r.actualHours
            $ThisObject.TicketSummary = $r.ticket.summary
            $ThisObject.TimeStart = $r.timeStart #>

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}