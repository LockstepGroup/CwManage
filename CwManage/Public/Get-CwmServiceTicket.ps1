function Get-CwmServiceTicket {
    [CmdletBinding(DefaultParametersetName = "NoId")]

    Param (
        [Parameter(Mandatory = $False, ParameterSetName = 'Id')]
        [Alias('Id')]
        [int[]]$TicketNumber,

        [Parameter(Mandatory = $False, ParameterSetName = 'NoId')]
        [string[]]$Status,

        [Parameter(Mandatory = $False, ParameterSetName = 'NoId')]
        [string[]]$NotStatus,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'NoId')]
        [string]$ServiceBoard,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'NoId')]
        [string]$Company,

        [Parameter(Mandatory = $False, ParameterSetName = 'NoId')]
        [string]$PageSize = 1000,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString
    )

    $VerbosePrefix = "Get-CwmServiceTicket:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "service/tickets"

    $ApiParams = @{}
    $ApiParams.AuthString = $AuthString

    switch ($PsCmdlet.ParameterSetName) {
        'NoId' {
            $QueryParams = @{}
            $QueryParams.pageSize = $PageSize


            $Conditions = @{}

            if ($Status) {
                $Conditions.'status/name' = $Status
            }

            if ($ServiceBoard) {
                $Conditions.'board/name' = $ServiceBoard
            }

            if ($Company) {
                $Conditions.'company/name' = $Company
            }

            if ($NotStatus) {
                $Conditions.'status/name!' = $NotStatus
            }

            $ApiParams.Uri = $Uri
            if ($QueryParams.Count -gt 0) { $ApiParams.QueryParams = $QueryParams }
            if ($Conditions.Count -gt 0) { $ApiParams.Conditions = $Conditions }

            $ReturnValue = Invoke-CwmApiCall @ApiParams
            $ReturnValue
        }
        'Id' {
            $ReturnObject = @()
            foreach ($ticket in $TicketNumber) {
                $ThisUri = $Uri + "/$ticket"
                $ApiParams.Uri = $ThisUri
                $ReturnValue = Invoke-CwmApiCall @ApiParams
                $ThisObject = New-Object ServiceTicket
                $ThisObject.ServiceTicket = $ReturnValue.Id
                $ThisObject.FullData = $ReturnValue
                $ReturnObject += $ReturnValue
            }
            $ReturnObject
        }
    }





}
