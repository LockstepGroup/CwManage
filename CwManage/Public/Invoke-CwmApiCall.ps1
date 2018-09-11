function Invoke-CwmApiCall {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$Uri,

        [Parameter(Mandatory = $false, Position = 1)]
        [Hashtable]$QueryParams,

        [Parameter(Mandatory = $false, Position = 2)]
        [Hashtable]$Conditions,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Invoke-CwmApiCall:"

    $ContentType = "application/json"

    $Headers = @{}
    $Headers.Authorization = "Basic $AuthString"

    if ($Conditions) {
        Write-Verbose "$VerbosePrefix Conditions found, enumerating"
        $ConditionString = [HelperWeb]::createConditionString($Conditions)
        Write-Verbose "$VerbosePrefix ConditionString: $ConditionString"
        if ($QueryParams) {
            $QueryParams.conditions = $ConditionString
        } else {
            $QueryParams = @{}
            $QueryParams.conditions = $ConditionString
        }
    }

    # Format QueryString
    if ($QueryParams) {
        $QueryString = [HelperWeb]::createQueryString($QueryParams)
        $Uri += $QueryString
    }
    $global:CwUri = $Uri

    Write-Verbose "$VerbosePrefix Requesting Uri: $Uri"
    $JsonResponse = Invoke-RestMethod -URI $Uri -Headers $Headers -ContentType $ContentType -Method Get

    #[HelperWeb]::createQueryString($queryString)

    if ($JsonResponse) {
        $JsonResponse
    } else {
        $false
    }
}