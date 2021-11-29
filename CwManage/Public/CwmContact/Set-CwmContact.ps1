function Set-CwmContact {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [CwmContact]$CwmContact,

        [Parameter(Mandatory = $True)]
        [string]$Body
    )

    BEGIN {
        $VerbosePrefix = "Set-CwmContact:"
    }

    PROCESS {
        $ApiParams = @{}
        $ApiParams.UriPath = 'company/contacts/' + $CwmContact.Id
        $ApiParams.Method = 'PATCH'
        $ApiParams.Body = $Body
    }

    END {
        Write-Verbose "$VerbosePrefix $($CwmCompany.Name)"
        Invoke-CwmApiQuery @ApiParams
    }
}