function Get-CwmAgreement {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$CompanyId,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll
    )

    $VerbosePrefix = "Get-CwmAgreement:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "finance/agreements"

    $Uri += "?pageSize=1000"

    #https://api-na.myconnectwise.net/v4_6_release/apis/3.0/finance/agreements?conditions=company/id=19471

    if ($CompanyId) {
        $Uri += '&conditions=company/id=' + $CompanyId
    }

    if (!($ShowAll)) {
        $Uri += " AND noEndingDateFlag=True"
    }

    $ReturnValue = Invoke-CwmApiCall -Uri $Uri -AuthString $AuthString
    $ReturnValue
}