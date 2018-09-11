function Invoke-CwmApiCall {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$Uri,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Invoke-CwmApiCall:"

    $ContentType = "application/json"

    $Headers = @{}
    $Headers.Authorization = "Basic $AuthString"

    Write-Verbose "$VerbosePrefix Requesting Uri: $Uri"
    $global:CwUri = $Uri
    $JsonResponse = Invoke-RestMethod -URI $Uri -Headers $Headers -ContentType $ContentType -Method Get

    if ($JsonResponse) {
        $JsonResponse
    } else {
        $false
    }
}