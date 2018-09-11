function Get-CwmCompany {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmCompany:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "company/companies"

    $Uri += "?pageSize=1000"


    if ($Name) {
        $Uri += '&conditions=name="' + $Name + '"'
    }

    $ReturnValue = Invoke-CwmApiCall -Uri $Uri -AuthString $AuthString
    $ReturnValue
}