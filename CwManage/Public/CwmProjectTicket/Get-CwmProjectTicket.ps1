function Get-CwmProjectTicket {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True,ParameterSetName = 'CwmProject')]
        [CwmProject]$CwmProject,

        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True,ParameterSetName = 'CwmProjectPhase')]
        [CwmProjectPhase]$CwmProjectPhase,

        [Parameter(Mandatory = $False)]
        [hashtable]$Conditions,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False)]
        [string]$PageSize = 1000
    )

    BEGIN {
        $VerbosePrefix = "Get-CwmProjectTicket:"

        $ReturnObject = @()
    }

    PROCESS {
        # conditions
        if (-not $Conditions) {
            $Conditions = @{}
        }

        if ($CwmProject) {
            $Conditions.'project/id' = $CwmProject.ProjectId
        }

        if ($CwmProjectPhase) {
            $Conditions.'phase/id' = $CwmProjectPhase.Id
            $Conditions.'project/id' = $CwmProjectPhase.ProjectId
        }

        $ApiParams = @{}
        $ApiParams.UriPath = 'project/tickets/'
        $ApiParams.Conditions = $Conditions
        $ApiParams.QueryParameters = @{}
        $ApiParams.QueryParameters.page = 1
        $ApiParams.QueryParameters.pageSize = $PageSize

        $Response = Invoke-CwmApiQuery @ApiParams

        foreach ($r in $Response) {
            $ThisObject = New-CwmProjectTicket
            $ThisObject.FullData = $r
            $ThisObject.Id = $r.id
            $ThisObject.ProjectId = $r.project.id
            $ThisObject.ProjectPhaseId = $r.phase.id

            $ThisObject.Company = $r.company.name
            $ThisObject.Summary = $r.summary
            $ThisObject.Status = $r.status.name

            $ReturnObject += $ThisObject
        }
    }

    END {
        $ReturnObject
    }
}
