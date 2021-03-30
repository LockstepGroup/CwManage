function Get-CwmProduct {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$OpportunityId,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions = @{},

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmProduct:"
        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if ($OpportunityId) {
            $Conditions.'opportunity/id' = $OpportunityId
        }

        $ApiParams = @{}
        $ApiParams.UriPath = 'procurement/products'
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
            $ThisObject = New-CwmProduct
            $ThisObject.Id = $r.id
            $ThisObject.FullData = $r

            $ThisObject.ProductId = $r.catalogItem.identifier
            $ThisObject.CustomerDescription = $r.customerDescription
            $ThisObject.Quantity = $r.quantity

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}
