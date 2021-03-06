function Get-CwmServiceBoard {
    [CmdletBinding()]
    [OutputType([ServiceBoard[]])]
    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [Alias('ServiceBoard')]
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

    if ($Name) {
        $Conditions.'name' = $Name
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
        $ThisObject.ServiceBoard = $r.name
        $ThisObject.Id = $r.id
        $ThisObject.FullData = $r
        $ReturnObject += $ThisObject
    }

    $ReturnObject
}