function Get-CwmProjectPhase {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [CwmProject]$CwmProject,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions,

        [Parameter(Mandatory = $False)]
        [switch]$ShowAll,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmProjectPhase:"

        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        if ($ProjectId) {
            $Conditions.'id' = $ProjectId
        }

        if ($CompanyId) {
            $Conditions.'company/id' = $CompanyId
        }

        if ($OpportunityId) {
            $Conditions.'opportunity/id' = $OpportunityId
        }

        if ($BoardName) {
            $Conditions.'board/name' = $BoardName
        }

        <# if (-not $ShowAll) {
            $Conditions.'closedFlag' = $false
        } #>

        $ApiParams = @{}
        $ApiParams.UriPath = 'project/projects/' + $CwmProject.ProjectId + '/phases'
        $ApiParams.Conditions = $Conditions
        $ApiParams.QueryParameters = @{}
        $ApiParams.QueryParameters.page = 1
        $ApiParams.QueryParameters.pageSize = $PageSize

        $Response = Invoke-CwmApiQuery @ApiParams

        foreach ($r in $Response) {
            $ThisObject = New-CwmProjectPhase
            $ThisObject.FullData = $r
            $ThisObject.Id = $r.id

            $ThisObject.ProjectId = $r.projectId
            $ThisObject.Description = $r.description
            $ThisObject.Status = $r.status.Name
            $ThisObject.BudgetHours = $r.budgetHours
            $ThisObject.ActualHours = $r.actualHours

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}
