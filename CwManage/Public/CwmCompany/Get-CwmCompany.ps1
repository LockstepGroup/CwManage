function Get-CwmCompany {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
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
        $VerbosePrefix = "Get-CwmCompany:"

        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        if ($CompanyId) {
            $Conditions.'id' = $CompanyId
        }

        $ApiParams = @{}
        $ApiParams.UriPath = 'company/companies'
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
            $ThisObject = New-CwmCompany
            $ThisObject.FullData = $r

            $ThisObject.Id = $r.id

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}