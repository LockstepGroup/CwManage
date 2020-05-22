Class CwmProjectPhase {
    [int]$Id
    $FullData

    [int]$ProjectId
    [string]$Description
    [string]$Status
    [int]$BudgetHours
    [int]$ActualHours

    #region Initiators
    ########################################################################

    # empty initiator
    CwmProjectPhase() {
    }

    ########################################################################
    #endregion Initiators
}
