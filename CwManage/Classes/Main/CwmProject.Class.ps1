Class CwmProject:ICloneable {
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

    # Clone
    [Object] Clone () {
        $CloneObject = [CwmProject]::New()
        foreach ($Property in ($this | Get-Member -MemberType Property))
        {
            $CloneObject.$($Property.Name) = $this.$($Property.Name)
        } # foreach
        return $CloneObject
    }
}