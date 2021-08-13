function Set-CwmProject {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipeline = $True)]
        [CwmProject]$CwmProject
    )

    BEGIN {
        $VerbosePrefix = "Set-CwmProject:"

        $ApiParams = @{}
        $ApiParams.UriPath = 'project/projects'
    }

    PROCESS {
        $CurrentProject = Get-CwmProject -ProjectId $CwmProject.ProjectId
        if (-not $CurrentProject) {
            Throw 'Project does not exist, this cmdlet currently only support modifying projects'
        }
    }

    END {
    }
}


 <#
     $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "service/tickets"

    $ApiParams = @{}
    $ApiParams.Uri = $Uri
    $ApiParams.AuthString = $AuthString
    $ApiParams.Method = 'Post'
    $ApiParams.Body = @{}

    $WhatIfMessage = "`r`n"
    $WhatIfMessage += "Updating Service Ticket`r`n"

    $ReturnObject = @()
    foreach ($config in $ConfigurationId) {
        $ApiParams.Body.Id = $config
        foreach ($ticket in $TicketNumber) {
            $ApiParams.Uri += '/' + $ticket + '/configurations'
            $WhatIfMessage += "Uri: $Uri`r`n"
            $WhatIfMessage += "Body: $($ApiParams.Body | ConvertTo-Json)`r`n"
            if ($PSCmdlet.ShouldProcess($WhatIfMessage)) {
                $ReturnValue = Invoke-CwmApiCall @ApiParams
            }
            $ReturnObject += $ReturnValue
        }
    }

    $ReturnObject
    #>