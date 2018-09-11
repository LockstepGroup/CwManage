function Get-CwmServiceTicket {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False)]
        [string[]]$Status,

        [Parameter(Mandatory = $False)]
        [string[]]$NotStatus,

        [Parameter(Mandatory = $False, ValueFromPipeline = $true)]
        [ServiceBoard]
        [string]
        $ServiceBoard,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmServiceTicket:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "service/tickets"

    $QueryParams = @{}
    $QueryParams.pageSize = $PageSize


    $Conditions = @{}

    if ($Status) {
        $Conditions.'status/name' = $Status
    }

    if ($ServiceBoard) {
        if ($ServiceBoard.GetType().Name -eq 'ServiceBoard') {
            $ServiceBoard = $ServiceBoard.Name
        }
        $Conditions.'board/name' = $ServiceBoard
    }

    if ($NotStatus) {
        $Conditions.'status/name!' = $NotStatus
    }


    $ApiParams = @{}
    $ApiParams.Uri = $Uri
    $ApiParams.AuthString = $AuthString
    $ApiParams.QueryParams = $QueryParams
    if ($Conditions.Count -gt 0) {
        $ApiParams.Conditions = $Conditions
    }
    $global:api = $ApiParams

    $ReturnValue = Invoke-CwmApiCall @ApiParams
    $ReturnValue
}
