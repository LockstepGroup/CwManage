function Get-CwmAgreement {
    [CmdletBinding()]
    [OutputType([Agreement[]])]
    Param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipelineByPropertyName = $True, ParameterSetName = "NoId")]
        [int]$CompanyId,

        [Parameter(Mandatory = $False, Position = 0, ParameterSetName = "Id")]
        [int]$AgreementId,

        [Parameter(Mandatory = $False, ParameterSetName = "NoId")]
        [int]$OpportunityId,

        [Parameter(Mandatory = $false)]
        [string]$AuthString = $global:CwAuthString,

        [Parameter(Mandatory = $False, ParameterSetName = "NoId")]
        [switch]$ShowAll,

        [Parameter(Mandatory = $False)]
        [switch]$CalculateBalance,

        [Parameter(Mandatory = $False, ParameterSetName = "NoId")]
        [string]$Status = 'Active',

        [Parameter(Mandatory = $False, ParameterSetName = "NoId")]
        [string]$PageSize = 1000
    )

    $VerbosePrefix = "Get-CwmAgreement:"

    $Uri = "https://api-na.myconnectwise.net/"
    $Uri += 'v4_6_Release/apis/3.0/'
    $Uri += "finance/agreements"

    $QueryParams = @{}
    $QueryParams.page = 1
    $QueryParams.pageSize = $PageSize

    $Conditions = @{}
    if (-not $AgreementId) {
        $Conditions.agreementStatus = $Status
    }

    if ($CompanyId) {
        $Conditions.'company/id' = $CompanyId
    }

    if ($AgreementId) {
        $Conditions.'id' = $AgreementId
    }

    if (!($ShowAll)) {
        #$Conditions.'noEndingDateFlag' = $true               # can't remember why I did this
    } else {
        $Conditions.Remove('agreementStatus')
    }

    if ($OpportunityId) {
        $Conditions.'opportunity/id' = $OpportunityId
    }

    $ApiParams = @{}
    $ApiParams.Uri = $Uri
    $ApiParams.AuthString = $AuthString
    $ApiParams.QueryParams = $QueryParams
    if ($Conditions.Count -gt 0) {
        $ApiParams.Conditions = $Conditions
    }

    $ApiParams = @{}
    $ApiParams.UriPath = 'finance/agreements'
    $ApiParams.Conditions = $Conditions
    $ApiParams.QueryParameters = @{}
    $ApiParams.QueryParameters.page = 1
    $ApiParams.QueryParameters.pageSize = $PageSize

    #$ReturnValue = Invoke-CwmApiCall @ApiParams
    $ReturnValue = Invoke-CwmApiQuery @ApiParams
    if ($ShowAll) {
        if ($ReturnValue.Count -eq $PageSize) {
            $QueryParams.page++
            $ApiParams.QueryParams = $QueryParams
            $MoreValues = Invoke-CwmApiCall @ApiParams
            $ReturnValue += $MoreValues
        }
    }

    $ReturnObject = @()
    foreach ($r in $ReturnValue) {
        $ThisObject = New-Object Agreement
        $ThisObject.AgreementId = $r.id
        $ThisObject.FullData = $r

        $ThisObject.Name = $r.name
        $ThisObject.AgreementType = $r.type.name
        $ThisObject.AgreementTypeId = $r.type.id
        $ThisObject.CompanyName = $r.company.name
        $ThisObject.Status = $r.agreementStatus

        $ThisObject.StartDate = $r.startDate
        if ($r.endDate) {
            $ThisObject.EndDate = $r.endDate
        }

        $ThisObject.ApplicationUnit = $r.applicationUnits
        $ThisObject.ApplicationLimit = $r.applicationLimit
        $ThisObject.ApplicationCycle = $r.applicationCycle

        $ThisObject.IsOneTime = $r.oneTimeFlag
        $ThisObject.CarryOverUnused = $r.carryOverUnused
        $ThisObject.CarryOverExpireDays = $r.expiredDays
        $ThisObject.ExpireWhenZero = $r.expireWhenZero

        # Calculate available hours
        # this is frankly, a ridiculous process and CW needs to expose an endpoint for it
        # in my org, we apply new agreement allotments at the beginning of the month
        # this triggers the expiration timer of the old hours that have carryover
        # no idea if it triggers it counting from that day or the day before, hopefully
        # it doesn't matter

        if ($CalculateBalance) {
            $TimeEntries = Get-CwmTimeEntry -AgreementId $ThisObject.AgreementId

            switch ($ThisObject.ApplicationCycle) {
                'CalendarMonth' {
                    $AvailableHours = @()

                    $CurrentDate = $ThisObject.StartDate

                    do {
                        # set dates
                        if ($NextApplicationDate) {
                            $StartDate = $NextApplicationDate
                        } else {
                            $StartDate = $CurrentDate
                        }
                        $NextApplicationDate = $StartDate.AddMonths(1).AddDays((-1 * $StartDate.Day) + 1)
                        Write-Verbose "$VerbosePrefix NextApplicationDate: $NextApplicationDate"

                        # accrue monthly hours
                        $HourAddition = "" | Select-Object `
                        @{Name = 'AddDate'; Expression = {$StartDate}},
                        @{Name = 'ExpirationDate'; Expression = {$NextApplicationDate.AddDays($ThisObject.CarryOverExpireDays)}},
                        @{Name = 'Hours'; Expression = {$ThisObject.ApplicationLimit}},
                        StartingBalance, UsedHours
                        $AvailableHours += $HourAddition

                        # time entries for this month
                        $ValidTimeEntries = $TimeEntries | Where-Object { $_.FullData.timeEnd -gt $StartDate -and $_.FullData.timeEnd -lt $NextApplicationDate }
                        $HoursThisMonth = ($ValidTimeEntries.FullData.actualHours | measure-Object -Sum).Sum * -1

                        # cycle through valid hour entries
                        $ValidAvailableHours = $AvailableHours | Where-Object { $_.ExpirationDate -gt $StartDate }
                        $HourAddition.StartingBalance = ($ValidAvailableHours.Hours | Measure-Object -Sum).Sum
                        $HourAddition.UsedHours = $HoursThisMonth
                        $BalanceForward = 0
                        foreach ($HourEntry in ($ValidAvailableHours | Sort-Object ExpirationDate)) {
                            $HourEntry.Hours += $HoursThisMonth
                            if ($HourEntry.Hours -lt 0) {
                                $BalanceForward = $HourEntry.Hours
                                $HourEntry.Hours = 0
                            }
                        }

                        $ThisObject.StartingBalance = (($AvailableHours | Where-Object { $_.ExpirationDate -ge $CurrentDate }).Hours | Measure-Object -Sum).Sum

                        Write-Verbose "$VerbosePrefix $CurrentDate`: $($ThisObject.StartingBalance)"

                        $CurrentDate = $EndDate

                    } while ($NextApplicationDate -lt (get-date))
                }
                '' {
                    $ThisObject.StartingBalance = $ThisObject.ApplicationLimit
                    Write-Verbose "$VerbosePrefix ApplicationCycle not set"
                    break
                }
                default {
                    Write-Warning "$VerbosePrefix unhandled ApplicationLimit: $($ThisObject.ApplicationCycle)"
                }
            }
        }

        if ($thisObject.AgreementId -eq 286) {
            $global:tAvailableHours = $AvailableHours
        }
        $ReturnObject += $ThisObject
    }

    $ReturnObject
}