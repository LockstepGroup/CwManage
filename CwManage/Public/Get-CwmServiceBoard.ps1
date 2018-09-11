function Get-CwmServiceBoard {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False)]
        [string]$Name,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmServiceBoard:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "service/boards"

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

    $ReturnObject = @()
    foreach ($r in $ReturnValue) {
        $ThisObject = New-Object ServiceBoard
        $ThisObject.Name = $r.name
        $ThisObject.Id = $r.id
        $ThisObject.FullData = $r
        $ReturnObject += $ThisObject
    }

    $ReturnObject
}