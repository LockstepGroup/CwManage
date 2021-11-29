Class CwmMember {
    [int]$MemberId
    $FullData

    [string]$FirstName
    [string]$LastName
    [string]$Identifier
    [string]$DefaultDepartment
    [string]$PrimaryEmail


    #region Initiators
    ########################################################################

    # empty initiator
    CwmMember() {
    }

    ########################################################################
    #endregion Initiators
}
