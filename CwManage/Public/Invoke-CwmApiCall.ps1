function Invoke-CwmApiCall {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$Uri,

        [Parameter(Mandatory = $false, Position = 1)]
        [Hashtable]$QueryParams,

        [Parameter(Mandatory = $false, Position = 2)]
        [Hashtable]$Conditions,

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$Method = 'Get',

        [Parameter(Mandatory = $false, Position = 5)]
        [HashTable]$Body,

        [Parameter(Mandatory = $false)]
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
    $global:Body = $Body

    Write-Verbose "$VerbosePrefix Requesting Uri: $Uri"

    $RestParams = @{}
    $RestParams.Uri = $Uri
    $RestParams.Headers = $Headers
    $RestParams.ContentType = $ContentType
    $RestParams.Method = $Method
    if ($Body) {
        $RestParams.Body = $Body | ConvertTo-Json -Compress -Depth 4
    }

    $JsonResponse = Invoke-RestMethod @RestParams

    if ($JsonResponse) {
        $JsonResponse
    } else {
        $false
    }
}