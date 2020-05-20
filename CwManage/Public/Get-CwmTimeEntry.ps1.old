function Get-CwmTimeEntry {
    [CmdletBinding()]
    [OutputType([TimeEntry[]])]
    Param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipelineByPropertyName = $True)]
        [int]$TicketId,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$ProjectId,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$CompanyId,

        [Parameter(Mandatory = $False)]
        [int]$OpportunityId,

        [Parameter(Mandatory = $False)]
        [string[]]$Member,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000
    )

    $VerbosePrefix = "Get-CwmTimeEntry:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    if ($ProjectId) {
        $Tickets = Get-CwmTicket -ProjectId $ProjectId
        $ReturnValue = foreach ($ticket in $Tickets) {
            $ThisUri = $Uri + "/project/tickets/$($ticket.TicketId)/timeentries"
            $ApiParams = @{}
            $ApiParams.Uri = $ThisUri
            $ApiParams.AuthString = $AuthString
            $TimeEntryIds = Invoke-CwmApiCall @ApiParams
            foreach ($entry in $TimeEntryIds) {
                $ThisUri = $Uri + "/time/entries/$($entry.TimeEntryId)"
                $ApiParams = @{}
                $ApiParams.Uri = $ThisUri
                $ApiParams.AuthString = $AuthString
                Invoke-CwmApiCall @ApiParams
            }
        }
    } else {
        $Uri += "ticket/tickets"
    }
    <#
    $QueryParams = @{}
    $QueryParams.page = 1
    $QueryParams.pageSize = $PageSize

    $Conditions = @{}

    if ($ProjectId) {
        $Conditions.'ticket/id' = $TicketId
    }

    if ($ProjectId) {
        $Conditions.'project/id' = $ProjectId
    }

    if ($CompanyId) {
        $Conditions.'company/id' = $CompanyId
    }

    if ($OpportunityId) {
        $Conditions.'opportunity/id' = $OpportunityId
    }

    if ($Member) {
        $Conditions.'member/identifier' = $Member
    }

    $ApiParams = @{}
    $ApiParams.Uri = $Uri
    $ApiParams.AuthString = $AuthString
    $ApiParams.QueryParams = $QueryParams
    if ($Conditions.Count -gt 0) {
        $ApiParams.Conditions = $Conditions
    }

    $ReturnValue = Invoke-CwmApiCall @ApiParams
    if ($ShowAll) {
        if ($ReturnValue.Count -eq $PageSize) {
            $QueryParams.page++
            $ApiParams.QueryParams = $QueryParams
            $MoreValues = Invoke-CwmApiCall @ApiParams
            $ReturnValue += $MoreValues
        }
    } #>

    $ReturnObject = @()
    foreach ($r in $ReturnValue) {
        $ThisObject = [TimeEntry]::new($r.id)
        #$ThisObject.TicketId = $r.id
        #$ThisObject.Name = $r.name
        $ThisObject.FullData = $r
        $ReturnObject += $ThisObject
    }

    $ReturnObject
}