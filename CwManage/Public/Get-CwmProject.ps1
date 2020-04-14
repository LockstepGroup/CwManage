function Get-CwmProject {
    [CmdletBinding()]
    [OutputType([Project[]])]
    Param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipelineByPropertyName = $True)]
        [int]$ProjectId,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$CompanyId,

        [Parameter(Mandatory = $False)]
        [int]$OpportunityId,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000
    )

    $VerbosePrefix = "Get-CwmProject:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "project/projects"

    $QueryParams = @{}
    $QueryParams.page = 1
    $QueryParams.pageSize = $PageSize

    $Conditions = @{}

    if ($ProjectId) {
        $Conditions.'id' = $ProjectId
    }

    if ($CompanyId) {
        $Conditions.'company/id' = $CompanyId
    }

    if ($OpportunityId) {
        $Conditions.'opportunity/id' = $OpportunityId
    }

    $ApiParams = @{}
    $ApiParams.Uri = $Uri
    $ApiParams.AuthString = $AuthString
    $ApiParams.QueryParams = $QueryParams
    if ($Conditions.Count -gt 0) {
        $ApiParams.Conditions = $Conditions
    }

    $ReturnValue = Invoke-CwmApiCall @ApiParams
    if ($ShowAll) {
        if ($ReturnValue.Count -eq $PageSize) {
            $QueryParams.page++
            $ApiParams.QueryParams = $QueryParams
            $MoreValues = Invoke-CwmApiCall @ApiParams
            $ReturnValue += $MoreValues
        }
    }

    $ReturnObject = @()
    foreach ($r in $ReturnValue) {
        $ThisObject = New-Object Project
        $ThisObject.ProjectId = $r.id
        $ThisObject.Name = $r.name
        $ThisObject.FullData = $r
        $ReturnObject += $ThisObject
    }

    $ReturnObject
}