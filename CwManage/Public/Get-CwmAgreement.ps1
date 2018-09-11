function Get-CwmAgreement {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$CompanyId,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000
    )

    $VerbosePrefix = "Get-CwmAgreement:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "finance/agreements"

    $QueryParams = @{}
    $QueryParams.pageSize = $PageSize

    $Conditions = @{}

    if ($CompanyId) {
        $Conditions.'company/id' = $CompanyId
    }

    if (!($ShowAll)) {
        $Conditions.'noEndingDateFlag' = $true
    }

    $ApiParams = @{}
    $ApiParams.Uri = $Uri
    $ApiParams.AuthString = $AuthString
    $ApiParams.QueryParams = $QueryParams
    if ($Conditions.Count -gt 0) {
        $ApiParams.Conditions = $Conditions
    }

    $ReturnValue = Invoke-CwmApiCall @ApiParams
    $ReturnValue
}