ipmo ./CwManage -Force

$ticketparams = @{}
$ticketparams.SubType = "Switching/Routing"
$ticketparams.Item = "Add"
$ticketparams.Summary = "new test ticket"
$ticketparams.Status = "Assigned"
$ticketparams.ServiceBoard = "Professional Services"
$ticketparams.Type = "Networking"

$company = Get-CwmCompany -Name "Bruce's Ice Cream Shoppe (TEST - DO NOT USE)"

$ticket = $company | New-CwmServiceTicket @ticketparams -WhatIf

<#
$docs = New-Object ([System.Collections.specialized.OrderedDictionary])
$docs.Add("name", "Johan");
$docs.Add("surname", "McGuinness");
$docs.Add("emails", @(
        @{ "personal" = "johnanmg@hotmmail.com" },
        @{ "professional" = "johan@gmmail.com" },
        @{ "personal" = "johnan_mguinness@yahooo.com" }
    ));


$Cmdlets = New-Object ([System.Collections.specialized.OrderedDictionary])
$Cmdlets.Add("Get-CwmAdjustment","Get-CwmAdjustment.md")

$Pages = New-Object ([System.Collections.specialized.OrderedDictionary])
$Pages.Add("Home","index.md")
$Pages.Add("Cmdlets",$CMdlets)

$docs = New-Object ([System.Collections.specialized.OrderedDictionary])
$docs.Add("repo_url", "https://github.com/LockstepGroup/CwManage")
$docs.Add("theme", "readthedocs")
$docs.Add("pages", $Pages)


    site_name: CwManage Docs
repo_url: https://github.com/LockstepGroup/CwManage
theme: readthedocs
pages:
  - Home: index.md
  - Cmdlets:
    -  #>