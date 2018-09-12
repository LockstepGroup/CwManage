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