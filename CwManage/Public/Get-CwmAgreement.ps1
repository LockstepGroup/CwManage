function Get-CwmAgreement {
    [CmdletBinding()]
    [OutputType([Agreement[]])]
    Param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipelineByPropertyName = $True)]
        [Alias('CompanyId')]
        [int]$Company,

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

    if ($Company) {
        $Conditions.'company/id' = $Company
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

    $ReturnObject = @()
    foreach ($r in $ReturnValue) {
        $ThisObject = New-Object Agreement
        $ThisObject.AgreementId = $r.id
        $ThisObject.FullData = $r
        $ReturnObject += $ThisObject
    }

    $ReturnObject
}