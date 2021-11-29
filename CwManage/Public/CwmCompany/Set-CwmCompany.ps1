function Set-CwmCompany {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [CwmCompany]$CwmCompany,

        [Parameter(Mandatory = $True)]
        [string]$Body
    )

    BEGIN {
        $VerbosePrefix = "Set-CwmCompany:"
    }

    PROCESS {
        $ApiParams = @{}
        $ApiParams.UriPath = 'company/companies/' + $Company.Id
        $ApiParams.Method = 'PATCH'
        $ApiParams.Body = $Body
    }

    END {
        Write-Verbose "$VerbosePrefix $($CwmCompany.Name)"
        Invoke-CwmApiQuery @ApiParams
    }
}