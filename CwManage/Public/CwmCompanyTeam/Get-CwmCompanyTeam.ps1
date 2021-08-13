function Get-CwmCompanyTeam {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$CompanyId,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmCompanyTeam:"
        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        $ApiParams = @{}
        $ApiParams.UriPath = "/company/companies/$CompanyId/teams"
        $ApiParams.Conditions = $Conditions
        $ApiParams.QueryParameters = @{}
        $ApiParams.QueryParameters.page = 1
        $ApiParams.QueryParameters.pageSize = $PageSize

        $Response = Invoke-CwmApiQuery @ApiParams

        if ($ShowAll) {
            $ResponseCount = $Response.Count
            do {
                $ApiParams.QueryParameters.page++
                $MoreValues = Invoke-CwmApiQuery @ApiParams
                $Response += $MoreValues
                $ResponseCount = $MoreValues.Count
            } while ($ResponseCount -eq $PageSize)
        }

        foreach ($r in $Response) {
            $ThisObject = New-CwmCompanyTeamMember
            $ThisObject.FullData = $r

            $ThisObject.Id = $r.id
            $ThisObject.TeamRole = $r.teamRole.name
            $ThisObject.MemberId = $r.member.identifier
            $ThisObject.MemberName = $r.member.name
            $ThisObject.AccountManager = $r.accountManagerFlag
            $ThisObject.Tech = $r.techFlag
            $ThisObject.Sales = $r.salesFlag

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}
