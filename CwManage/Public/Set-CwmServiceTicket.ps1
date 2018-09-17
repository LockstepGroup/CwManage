function Set-CwmServiceTicket {
    [CmdletBinding(SupportsShouldProcess = $True)]

    Param (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('TicketId')]
        [int[]]$TicketNumber,

        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [int[]]$ConfigurationId,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Set-CwmServiceTicket:"

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
}
