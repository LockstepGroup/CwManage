[CmdletBinding()]
Param (
)
ipmo ./CwManage -Force

Connect-CwmServer

$Opp = Get-CwmOpportunity -OpportunityId 7685
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
}