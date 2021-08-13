function Get-CwmContact {
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
        $VerbosePrefix = "Get-CwmContact:"
        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        if ($CompanyId) {
            $Conditions.'company/id' = $CompanyId
        }

        $ApiParams = @{}
        $ApiParams.UriPath = "/company/contacts"
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
            $ThisObject = New-CwmContact
            $ThisObject.FullData = $r

            $ThisObject.Id = $r.id

            $ThisObject.FirstName = $r.firstName
            $ThisObject.LastName = $r.lastName
            $ThisObject.CompanyName = $r.company.Name
            $ThisObject.EmailAddress = ($r.communicationItems | Where-Object { $_.communicationType -eq 'Email' }).value
            $ThisObject.PhoneNumber = ($r.communicationItems | Where-Object { $_.communicationType -eq 'Phone' }).value

            $ThisObject.Active = (-not $r.inactiveFlag)

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}
