<# function New-CwmServiceTicket {
    [CmdletBinding(SupportsShouldProcess = $True)]

    Param (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 100)]
        [string]$Summary,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string]$InternalNotes,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [Alias('ServiceBoardName')]
        [string]$ServiceBoard,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [string]$CompanyId,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
        [int]$AgreementId,

        [Parameter(Mandatory = $true)]
        [string]$Status,

        [Parameter(Mandatory = $true)]
        [string]$Type,

        [Parameter(Mandatory = $true)]
        [string]$Subtype,

        [Parameter(Mandatory = $true)]
        [string]$Item,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [int]$ConfigurationId,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmServiceTicket:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "service/tickets"

    $ApiParams = @{}
    $ApiParams.Uri = $Uri
    $ApiParams.AuthString = $AuthString
    $ApiParams.Method = 'Post'

    $ApiParams.Body = @{}

    # required parameters
    $ApiParams.Body.Summary = $Summary
    $ApiParams.Body.Board = @{}
    $ApiParams.Body.Board.Name = $ServiceBoard
    $ApiParams.Body.Company = @{}
    $ApiParams.Body.Company.id = $CompanyId

    $WhatIfMessage = "`r`n"
    $WhatIfMessage += "Creating Service Ticket`r`n"
    $WhatIfMessage += "Summary: $Summary`r`n"
    $WhatIfMessage += "ServiceBoard: $ServiceBoard`r`n"
    $WhatIfMessage += "CompanyId: $CompanyId`r`n"

    if ($Description) {
        $ApiParams.Body.InitialDescription = $Description
        $WhatIfMessage += "Description: $Description`r`n"
    }

    if ($InternalNotes) {
        $ApiParams.Body.initialInternalAnalysis = $InternalNotes
        $WhatIfMessage += "InternalNotes: $InternalNotes`r`n"
    }

    if ($Agreement) {
        $ApiParams.Body.Agreement = @{}
        $ApiParams.Body.Agreement.Id = $AgreementId
        $WhatIfMessage += "AgreementId: $AgreementId`r`n"
    }

    if ($Status) {
        $ApiParams.Body.Status = @{}
        $ApiParams.Body.Status.Name = $Status
        $WhatIfMessage += "Status: $Status`r`n"
    }

    if ($Type) {
        $ApiParams.Body.Type = @{}
        $ApiParams.Body.Type.Name = $Type
        $WhatIfMessage += "Type: $Type`r`n"
    }

    if ($Subtype) {
        $ApiParams.Body.Subtype = @{}
        $ApiParams.Body.Subtype.Name = $Subtype
        $WhatIfMessage += "Subtype: $Subtype`r`n"
    }

    if ($Item) {
        $ApiParams.Body.Item = @{}
        $ApiParams.Body.Item.Name = $Item
        $WhatIfMessage += "Item: $Item`r`n"
    }

    $WhatIfMessage += "Uri: $Uri"

    $ApiParams.Body = $ApiParams.Body

    if ($PSCmdlet.ShouldProcess($WhatIfMessage)) {
        $CreateTicket = Invoke-CwmApiCall @ApiParams
        $ReturnValue = New-Object ServiceTicket
        $ReturnValue.TicketId = $CreateTicket.Id

        # Attach a configuratin if desired
        if ($ConfigurationId) {
            $ApiParams.Uri += '/' + $ReturnValue.TicketId + '/configurations'

            $ApiParams.Body = @{}
            $ApiParams.Body.Id = $ConfigurationId
            $AddConfiguration = Invoke-CwmApiCall @ApiParams
        }

        $ReturnValue = Get-CwmServiceTicket -TicketNumber $ReturnValue.TicketId
        $ReturnValue
    }
}
 #>