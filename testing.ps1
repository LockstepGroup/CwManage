[CmdletBinding()]
Param (
)
ipmo ./CwManage -Force

<# $global:CwmCompany = $global:CwCompany
$global:CwmPublicKey = $global:CwPublicKey
$global:CwmPrivateKey = $global:CwPrivateKey
$global:CwmClientId = $global:CwClientId
$global:CwmAuthString = New-CwmAuthString #>

Connect-CwmServer
#$Agreements = Get-CwmAgreement
$ThisAgreement = $Agreements | ? { $_.Agreementid -eq 296}
$ThisAgreement = $Agreements | ? { $_.Agreementid -eq 351}
$ThisAgreement = $Agreements | ? { $_.Agreementid -eq 294}

function Get-CwmAgreementAvailableHours {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        $Agreement
    )

    $ThisAgreement = $Agreement

    $TimeEntries = Get-CwmTimeEntry -AgreementId $ThisAgreement.AgreementId -Verbose:$false -ShowAll
    $TimeEntries = $TimeEntries | Where-Object { $_.FullData.billableOption -eq 'Billable'}

    $StartDate = $ThisAgreement.StartDate

    $Hours = @()
    $LeftoverHours = 0

    $Tally = @()

    do {
        Write-Verbose "$StartDate adding $($ThisAgreement.ApplicationLimit) $($ThisAgreement.ApplicationUnit)"

        #region accrueHours
        #############################################################

        # get expiry date
        if ($ThisAgreement.CarryOverUnused) {
            if($ThisAgreement.CarryOverExpireDays -gt 0) {
                $ExpireDate = $StartDate.AddMonths(1).AddDays(-1).AddDays($ThisAgreement.CarryOverExpireDays).AddSeconds(-1)
            } else {
                $ExpireDate = (Get-Date).AddYears(1)
            }
        } else {
            if ($ThisAgreement.IsOneTime) {
                if ($ThisAgreement.EndDate -eq (get-date 1/1/0001)) {
                    $ExpireDate = (Get-Date).AddYears(1)
                } else {
                    $ExpireDate = $ThisAgreement.EndDate
                }
            } else {
                switch ($ThisAgreement.ApplicationCycle) {
                    'CalendarMonth' {
                        $ExpireDate = $StartDate.AddMonths(1).AddSeconds(-1)
                        break
                    }
                    'ContractYear' {
                        $ExpireDate = $StartDate.AddYears(1).AddSeconds(-1)
                        break
                    }
                    'ContractQuarter' {
                        $ExpireDate = $StartDate.AddMonths(3).AddSeconds(-1)
                        break
                    }
                    'CalendarQuarter' {
                        $ExpireDate = $StartDate.AddMonths(3).AddSeconds(-1)
                        break
                    }
                    default {
                        Throw "ApplicationCycle unsupported: $($ThisAgreement.ApplicationCycle)"
                    }
                }

            }
        }

        # add new hours
        $NewEntry = "" | Select-Object AddDate,ExpireDate,Hours,TotalHours
        $NewEntry.AddDate = $StartDate
        $NewEntry.ExpireDate = $ExpireDate
        $NewEntry.Hours = $ThisAgreement.ApplicationLimit
        $NewEntry.TotalHours = $NewEntry.Hours + $Hours[-1].TotalHours

        $Hours += $NewEntry

        $new = "" | Select-Object Date,Action,Hours,TotalHours
        $new.Date = $StartDate
        $new.Action = 'AddHours'
        $new.Hours = $ThisAgreement.ApplicationLimit

        $Tally += $new

        # add expiration event
        $new = "" | Select-Object Date,Action,Hours,TotalHours
        $new.Date = $ExpireDate
        $new.Action = 'Expire'

        $Tally += $new

        #############################################################
        #endregion accrueHours

        switch ($ThisAgreement.ApplicationCycle) {
            'CalendarMonth' {
                $StartDate = Get-Date "$($StartDate.AddMonths(1).Month)/1/$($StartDate.AddMonths(1).Year)"
                break
            }
            'ContractYear' {
                $StartDate = $StartDate.AddYears(1)
            }
            'ContractQuarter' {
                $StartDate = $StartDate.AddMonths(3)
            }
            'CalendarQuarter' {
                $StartDate = Get-Date "$($StartDate.AddMonths(3).Month)/1/$($StartDate.AddMonths(1).Year)"
            }
            '' {
                $StartDate = (Get-Date).AddDays(1)
                break
            }
            default {
                Throw "ApplicationCycle unsupported: $($ThisAgreement.ApplicationCycle)"
            }
        }

    } while ($StartDate -le (Get-Date))



    foreach ($entry in $TimeEntries) {
        $new = "" | Select-Object Date,Action,Hours,TotalHours
        $new.Date = $entry.TimeStart.AddSeconds(1)
        $new.Action = 'TimeEntry'
        $new.Hours = $entry.ActualHours

        $Tally += $new
    }

    $global:oldtally = $Tally

    $NewTally = @()

    foreach ($t in ($Tally | Sort-Object Date)) {
        if ($t.Date -gt (get-date)) {
            continue
        }
        $new = "" | Select-Object Date,Action,Hours,TotalHours
        $new.Date = $t.Date
        $new.Action = $t.Action
        $new.Hours = $t.Hours

        switch ($t.Action) {
            'AddHours' {
                if ($NewTally[-1].TotalHours -lt 0) {
                    if (-not $ThisAgreement.FullData.allowOverruns) {
                        $new.TotalHours = $new.Hours
                    }
                } else {
                    $new.TotalHours = $NewTally[-1].TotalHours + $new.Hours
                }
            }
            'TimeEntry' {
                # something weird here, need to be able to not subtract overage from next month
                $ThisHours = $Hours | ? { $_.ExpireDate -gt $t.Date -and $_.Hours -gt 0 -and $_.AddDate -le $t.Date}
                if ($ThisHours) {
                    $ThisHours[0].Hours -= $t.Hours
                    if ($ThisHours[0].Hours -lt 0 -and $ThisHours[1]) {
                        $ThisHours[1].Hours += $ThisHours[0].Hours
                    }
                }
                $new.TotalHours = $NewTally[-1].TotalHours - $new.Hours
            }
            'Expire' {
                $ThisHours = $Hours | ? { $_.ExpireDate -eq $t.Date }
                $new.Hours = $ThisHours.Hours
                $new.TotalHours = $NewTally[-1].TotalHours - $ThisHours.Hours
                $ThisHours.Hours = 0
            }
        }

        $NewTally += $new
    }

    $global:oldhours = $Hours
    #$NewTally[-1].TotalHours
    $NewTally
}

$Report = Import-Csv '/Users/brian/Downloads/report (4).csv'

$ManualAdjustments = @{}
$ManualAdjustments.55 = -303.87
$ManualAdjustments.123 = -22.25
$ManualAdjustments.267 = 45


$i = 0
$AllAvailable = @()
foreach ($agreement in $Agreements) {
    <# if ($agreement.ApplicationUnit -ne 'Hours') {
        continue
    } #>

    if ($agreement.CompanyName -eq 'Lockstep Technology Group') {
        continue
    }
    $i++

    $AgreementId = $agreement.AgreementId

    Write-Warning "$i/$($Agreements.Count): $AgreementId`: $($agreement.CompanyName) - $($agreement.Name)"
    $new = "" | Select-Object Company,Name,Id,ReportAvailable,Available,Tally,Agreement
    $new.Company = $agreement.CompanyName
    $new.Name = $agreement.Name
    $new.Id = $AgreementId
    $new.Tally = Get-CwmAgreementAvailableHours $agreement
    $new.Available = $new.Tally[-1].TotalHours + $ManualAdjustments.$AgreementId
    $new.Agreement = $agreement

    $ReportLookup = $Report | ? { $_.Company_Name -eq $new.Company -and $_.AGR_Name -eq $new.Name }
    if ($ReportLookup) {
        if ($ReportLookup.Balance_Amount -eq '') {
            $New.ReportAvailable = $ReportLookup.Balance_Hours
        } else {
            $New.ReportAvailable = $ReportLookup.Balance_Amount
        }
    }

    $AllAvailable += $new
} #>

<# $Projects = Get-CwmProject -BoardName 'Professional Services Projects'
$Projects += Get-CwmProject -BoardName 'Security'
$Phases = $Projects[0] | Get-CwmProjectPhase

$ProjectTickets = $Projects[0] | Get-CwmProjectTicket

$ReturnObject = @()
foreach ($p in $Projects) {
    $new = "" | Select Company,Project,ProjectId,PhaseCount
    $new.Company = $p.Company
    $new.ProjectId = $p.ProjectId
    $new.Project = $p.Name

    $Phases = $p | Get-CwmProjectPhase
    $new.PhaseCount = ($Phases | ? { $_.Status -ne 'Closed' }).Count

    $ReturnObject += $new
} #>

<#
$WrikeInput = @()

foreach ($agreement in $Agreements) {
    $new = "" | Select-Object Company, Title, PurchasedHours, RemainingHours, AgreementType, AgreementCycle, CarryOver, Expiration, CwLink, AgreementId
    $WrikeInput += $new

    $new.Company = $agreement.CompanyName
    $new.Title = $agreement.Name
    $new.PurchasedHours = $agreement.StartingBalance
    #$new.RemainingHours = $agreement.AgreementId
    $new.AgreementType = $agreement.AgreementType
    $new.AgreementCycle = $agreement.ApplicationCycle

    if ($agreement.CarryOverUnused) {
        if ($agreement.CarryOverExpireDays -eq 0) {
            $new.CarryOver = 'unrestricted'
        } else {
            $new.CarryOver = "$($agreement.CarryOverExpireDays) days"
        }
    }

    if ($agreement.EndDate -ne [datetime]'1/1/0001') {
        $new.Expiration = $agreement.EndDate
    }

    $new.AgreementId = $agreement.AgreementId
} #>

<#

Name                : Retainer Agreement General Services
AgreementType       : Block Time - Recurring
AgreementTypeId     : 14
CompanyName         : ASHRAE
Status              : Active
StartDate           : 5/8/2019 12:00:00 AM
EndDate             : 1/1/0001 12:00:00 AM
ApplicationUnit     : Hours
ApplicationLimit    : 10
IsOneTime           : False
CarryOverUnused     : True
CarryOverExpireDays : 30
ExpireWhenZero      : False


$Projects = Get-CwmProject -BoardName 'Professional Services Projects'


$ticketparams = @{}
$ticketparams.SubType = "Switching/Routing"
$ticketparams.Item = "Add"
$ticketparams.Summary = "new test ticket"
$ticketparams.Status = "Assigned"
$ticketparams.ServiceBoard = "Professional Services"
$ticketparams.Type = "Networking" #>

#$company = Get-CwmCompany -Name "Bruce's Ice Cream Shoppe (TEST - DO NOT USE)"

#$ticket = $company | New-CwmServiceTicket @ticketparams -WhatIf

function formatConditionValue ($value) {
    if ($value.GetType().Name -eq 'String') {
        $formatedValue = '"' + [System.Uri]::EscapeDataString($value) + '"'
        return $formatedValue
    } else {
        return $value
    }
}

function createConditionString ([hashtable]$hashTable) {
    $returnString = ""
    $ConditionRx = [regex] '(?<operator>[=!<>]+|like(?=\s))(?<value>.+)'
    foreach ($hash in $hashTable.GetEnumerator()) {
        $global:hash = $hash
        $ConditionMatch = $ConditionRx.Match($hash.Value)
        if ($ConditionMatch.Success) {
            $Operator = $ConditionMatch.Groups['operator'].Value
            $ConditionValue = $ConditionMatch.Groups['value'].Value
        } else {
            $Operator = '='
            $ConditionValue = $hash.Value
        }
        if ($hash.Value.GetType().BaseType.Name -eq 'Array') {
            foreach ($v in $hash.Value) {
                if ($returnString.Length -gt 0) {
                    $returnString += ' and '
                }
                $returnString += $hash.Name + $Operator + $this.formatConditionValue($ConditionValue)
            }
        } else {
            if ($returnString.Length -gt 0) {
                $returnString += ' and '
            }
            if ($Operator -match '[a-zA-Z]') {
                $Operator = ' ' + $Operator + ' '
            }
            $returnString += $hash.Name + $Operator + (formatConditionValue $conditionValue.Trim())
        }
    }
    return $returnString
}