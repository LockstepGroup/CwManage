function Get-CwmConfiguration {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [Alias('ConfigurationName')]
        [string]$Name,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [Alias('CompanyName')]
        [string]$Company,

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

    if ($Company) {
        $Conditions.'company/name' = [System.Web.HttpUtility]::UrlEncode($Company)
    }

    if ($Name) {
        $Conditions.'name' = [System.Web.HttpUtility]::UrlEncode($Name)
    }

    $ApiParams = @{}
    $ApiParams.Uri = $Uri
    $ApiParams.AuthString = $AuthString
    $ApiParams.QueryParams = $QueryParams
    if ($Conditions.Count -gt 0) {
        $ApiParams.Conditions = $Conditions
    }

    $ReturnValue = Invoke-CwmApiCall @ApiParams

    $ReturnObject = @()
    foreach ($r in $ReturnValue) {
        $ThisObject = New-Object CwConfiguration
        $ThisObject.ConfigurationName = $r.name
        $ThisObject.ConfigurationId = $r.id
        $ThisObject.FullData = $r
        $ReturnObject += $ThisObject
    }

    $ReturnObject
}
