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
$Projects = Get-CwmProject -BoardName 'Professional Services Projects'
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
}

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