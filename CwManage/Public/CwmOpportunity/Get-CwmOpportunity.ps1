function Get-CwmOpportunity {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$OpportunityId,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmOpportunity:"
        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        if ($OpportunityId) {
            $Conditions.'id' = $OpportunityId
        }

        $ApiParams = @{}
        $ApiParams.UriPath = 'sales/opportunities'
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
            $ThisObject = New-CwmOpportunity
            $ThisObject.Id = $r.id
            $ThisObject.FullData = $r

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}