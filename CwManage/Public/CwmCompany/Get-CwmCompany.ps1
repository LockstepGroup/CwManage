function Get-CwmCompany {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$CompanyId,

        [Parameter(Mandatory = $False)]
        [Alias("Name")]
        [string]$CompanyName,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions,

        [Parameter(Mandatory = $False)]
        [hashtable]$QueryParameters,

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

        if ($CompanyName) {
            $Conditions.name = $CompanyName
        }

        $ApiParams = @{}
        $ApiParams.UriPath = 'company/companies'
        $ApiParams.Conditions = $Conditions

        if ($QueryParameters) {
            $ApiParams.QueryParameters = $QueryParameters
        } else {
            $ApiParams.QueryParameters = @{}
        }

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
            $ThisObject.Name = $r.name
            $ThisObject.ShortName = $r.identifier
            $ThisObject.Type = $r.types.name

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}