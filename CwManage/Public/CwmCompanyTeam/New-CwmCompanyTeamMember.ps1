function New-CwmCompanyTeamMember {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-CwmCompanyTeamMember:"
    }

    PROCESS {
        $ReturnObject = [CwmCompanyTeamMember]::new()
    }

    END {
        $ReturnObject
    }
}
