function Get-CwmMember {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string]$DefaultDepartment,

        [Parameter(Mandatory = $False)]
        [string]$Identifier,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions,

        [Parameter(Mandatory = $False)]
        [switch]$IncludeInactive,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmMember:"

        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        if ($DefaultDepartment) {
            $Conditions.'defaultDepartment/name' = $DefaultDepartment
        }

        if (-not $IncludeInactive) {
            $Conditions.'inactiveFlag' = $false
        }

        if ($Identifier) {
            $Conditions.'identifier' = $Identifier
        }

        $ApiParams = @{}
        $ApiParams.UriPath = 'system/members'
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
            $ThisObject = New-CwmMember
            $ThisObject.FullData = $r

            $ThisObject.MemberId = $r.id
            $ThisObject.FullData = $r
            $ThisObject.FirstName = $r.firstName
            $ThisObject.LastName = $r.lastName
            $ThisObject.Identifier = $r.identifier
            $ThisObject.DefaultDepartment = $r.defaultDepartment.name

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}