function Get-CwmConfiguration {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False)]
        [string]$CompanyName,

        [Parameter(Mandatory = $False)]
        [string]$ConfigurationName,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmConfiguration:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "company/configurations"

    $QueryParams = @{}
    $QueryParams.pageSize = $PageSize

    $Conditions = @{}

    if ($CompanyName) {
        $Conditions.'company/name' = [System.Web.HttpUtility]::UrlEncode($CompanyName)
    }

    if ($ConfigurationName) {
        $Conditions.'name' = [System.Web.HttpUtility]::UrlEncode($ConfigurationName)
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
