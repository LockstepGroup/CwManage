[CmdletBinding()]
Param (
)
ipmo ./CwManage -Force

Connect-CwmServer

$InterestingEmployees =@()
$InterestingEmployees += 'baddicks'
$InterestingEmployees += 'bperez'
$InterestingEmployees += 'cpurcell'
$InterestingEmployees += 'dwilliams'
$InterestingEmployees += 'fbyron'
$InterestingEmployees += 'jkyle'
$InterestingEmployees += 'jsanders'
$InterestingEmployees += 'kwilson'
$InterestingEmployees += 'mworley'
$InterestingEmployees += 'msimpson'
$InterestingEmployees += 'msmith'
$InterestingEmployees += 'nmuragian'
$InterestingEmployees += 'naddicks'
$InterestingEmployees += 'pmcgann'
$InterestingEmployees += 'prehkopf'
$InterestingEmployees += 'pvance'
$InterestingEmployees += 'sanctil'
$InterestingEmployees += 'tstrish'
$InterestingEmployees += 'vnettles'

$Members = Get-CwmMember

$InterestingMembers = $Members | Where-Object { $InterestingEmployees -contains $_.Identifier}

<# $Opp = Get-CwmOpportunity -OpportunityId 7685
$Product = Get-CwmProduct -OpportunityId 7685

$UniqueProducts = $Product | Select-Object ProductId,CustomerDescription -Unique

$AllProducts = @()
foreach ($prod in $UniqueProducts) {
    $ProductCount = ($Product | ? { $_.ProductId -eq $prod.ProductId } | Measure-Object -Property Quantity -Sum).Sum
    for ($i = 1;$i -le $ProductCount; $i++) {
        $New = "" | Select-Object ProductId,Description

        $New.ProductId = $prod.ProductId
        $New.Description = $prod.CustomerDescription

        $AllProducts += $New
    }
} #>