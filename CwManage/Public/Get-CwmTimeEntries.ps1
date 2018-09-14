function Get-CwmTimeEntries {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [Alias('AgreementId')]
        [string]$Agreement,

        [Parameter(Mandatory = $False)]
        [string[]]$Member,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmTimeEntries:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "time/entries"

    $QueryParams = @{}
    $QueryParams.pageSize = $PageSize


    $Conditions = @{}

    if ($AgreementId) {
        $Conditions.'agreement/id' = $AgreementId
    }

    if ($Member) {
        $Conditions.'member/identifier' = $Member
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