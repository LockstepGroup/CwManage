function Set-CwmProject {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True,ParameterSetName = 'CwmProject')]
        [CwmProject]$CwmProject,

        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True,ParameterSetName = 'ProjectId')]
        [int]$ProjectId,

        [Parameter(Mandatory = $True)]
        [string]$Body
    )

    BEGIN {
        $VerbosePrefix = "Set-CwmProject:"

        $ApiParams = @{}
        $ApiParams.Method = 'PATCH'
        $ApiParams.Body = $Body
    }

    PROCESS {
        if ($CwmProject) {
            $ProjectId = $CwmProject.ProjectId
        }
        $CurrentProject = Get-CwmProject -ProjectId $ProjectId
        if (-not $CurrentProject) {
            Throw 'Project does not exist, this cmdlet currently only support modifying projects'
        } else {
            $ApiParams.UriPath = 'project/projects/' + $ProjectId
        }
    }

    END {
        Invoke-CwmApiQuery @ApiParams
    }
}