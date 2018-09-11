function Get-CwmTimeEntries {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$AgreementId,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmTimeEntries:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "time/entries"

    $Uri += "?pageSize=1000"

    if ($AgreementId) {
        $Uri += '&conditions=agreement/id=' + $AgreementId
    }

    $ReturnValue = Invoke-CwmApiCall -Uri $Uri -AuthString $AuthString
    $ReturnValue
}