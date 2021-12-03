function Set-CwmProject {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [CwmProject]$CwmProject,

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
        $CurrentProject = Get-CwmProject -ProjectId $CwmProject.ProjectId
        if (-not $CurrentProject) {
            Throw 'Project does not exist, this cmdlet currently only support modifying projects'
        } else {
            $ApiParams.UriPath = 'project/projects/' + $CwmProject.ProjectId
        }
    }

    END {
        Invoke-CwmApiQuery @ApiParams
    }
}