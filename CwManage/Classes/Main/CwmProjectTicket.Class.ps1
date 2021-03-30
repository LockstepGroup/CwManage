Class CwmProjectTicket {
    [int]$Id
    [int]$ProjectId
    [int]$ProjectPhaseId

    [string]$Company
    [string]$Summary
    [string]$Status

    $FullData

    #region Initiators
    ########################################################################

    # empty initiator
    CwmProjectTicket() {
    }

    ########################################################################
    #endregion Initiators
}
