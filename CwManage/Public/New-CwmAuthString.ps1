function New-CwmAuthString {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$CwCompany = $global:CwCompany,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$CwPublicKey = $global:CwPublicKey,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$CwPrivateKey = $global:CwPrivateKey
    )

    $VerbosePrefix = "New-CwmAuthString:"

    foreach ($param in @('Company', 'PublicKey', 'PrivateKey')) {
        if ($null -eq $param) {
            Throw "Company, PublicKey, PrivateKey cannot be null. Either specify them explicitly or set them as global variables."
        }
    }

    $AuthString = $CwCompany + '+' + $CwPublicKey + ':' + $CwPrivateKey
    Write-Verbose "$VerbosePrefix $AuthString"
    $EncodedAuthString = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(($Authstring)));

    return $EncodedAuthString
}