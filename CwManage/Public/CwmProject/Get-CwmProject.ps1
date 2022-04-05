function Get-CwmProject {
    [CmdletBinding()]
    [OutputType([CwmProject[]])]
    Param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipelineByPropertyName = $True)]
        [int]$ProjectId,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$CompanyId,

        [Parameter(Mandatory = $False)]
        [int]$OpportunityId,

        [Parameter(Mandatory = $False)]
        [string]$BoardName,

        [Parameter(Mandatory = $False)]
        [hashtable]$QueryParameters,

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
        $VerbosePrefix = "Get-CwmProject:"

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

        if (-not $ShowAll) {
            $Conditions.'closedFlag' = $false
        }

        $ApiParams = @{}

        if ($QueryParameters) {
            $ApiParams.QueryParameters = $QueryParameters
        } else {
            $ApiParams.QueryParameters = @{}
        }

        $ApiParams.UriPath = 'project/projects'
        $ApiParams.Conditions = $Conditions
        $ApiParams.QueryParameters.page = 1
        $ApiParams.QueryParameters.pageSize = $PageSize

        $Response = Invoke-CwmApiQuery @ApiParams

        foreach ($r in $Response) {
            $ThisObject = New-CwmProject
            $ThisObject.FullData = $r

            $ThisObject.ProjectId = $r.id
            $ThisObject.Name = $r.name
            $ThisObject.Board = $r.board.name
            $ThisObject.Company = $r.company.name
            $ThisObject.CompanyShortName = $r.company.identifier
            $ThisObject.Description = $r.Description
            $ThisObject.Location = $r.location.name
            $ThisObject.Manager = $r.manager.name
            $ThisObject.Status = $r.status.name
            $ThisObject.Type = $r.type.name
            $ThisObject.BudgetHours = $r.budgetHours
            $ThisObject.ActualHours = $r.actualHours
            $ThisObject.OpportunityId = $r.opportunity.id
            $ThisObject.BillingMethod = $r.billingMethod
            $ThisObject.BudgetAnalysis = $r.budgetAnalysis

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}