function Get-CwmCompany {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmCompany:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "company/companies"

    $QueryParams = @{}
    $QueryParams.page = 1
    $QueryParams.pageSize = $PageSize

    $Conditions = @{}

    if ($Name) {
        $Conditions.'name' = $Name
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
        $KeepGoing = $true
        Write-Verbose ($QueryParams.page * $PageSize)
        while ($ReturnValue.Count -eq ($QueryParams.page * $PageSize)) {
            $QueryParams.page++
            $ApiParams.QueryParams = $QueryParams
            $MoreValues = Invoke-CwmApiCall @ApiParams
            $ReturnValue += $MoreValues
        }
    }

    $ReturnObject = @()
    foreach ($r in $ReturnValue) {
        $ThisObject = New-Object Company
        $ThisObject.CompanyName = $r.name
        $ThisObject.CompanyId = $r.id
        $ThisObject.FullData = $r
        $ReturnObject += $ThisObject
    }

    $ReturnObject
}