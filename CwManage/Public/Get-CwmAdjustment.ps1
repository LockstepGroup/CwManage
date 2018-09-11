function Get-CwmAdjustment {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$AgreementId,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmAdjustment:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "finance/agreements/"
    $Uri += $AgreementId
    $uri += '/adjustments'

    $Uri += "?pageSize=1000"

    $ReturnValue = Invoke-CwmApiCall -Uri $Uri -AuthString $AuthString
    $ReturnValue
}
