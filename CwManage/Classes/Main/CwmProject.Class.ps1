Class CwmProject {
    [int]$ProjectId
    $FullData

    [string]$Name
    [string]$Board
    [string]$Company
    [string]$CompanyShortName
    [string]$Description
    [string]$Location
    [string]$Manager
    [string]$Status
    [string]$BillingMethod
    [string]$BudgetAnalysis
    [int]$BudgetHours
    [int]$ActualHours
    [int]$OpportunityId

    #region Initiators
    ########################################################################

    # empty initiator
    CwmProject() {
    }

    ########################################################################
    #endregion Initiators
}

<#
Customer Name
Customer Shortname
Project Name
Project Id
Project Type (fixed fee, tm), comes from Finance/Billing Method
Hours Budget
Hours remaining
CwLink if possible
Status
#>