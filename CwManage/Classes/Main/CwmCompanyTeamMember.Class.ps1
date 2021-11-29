Class CwmCompanyTeamMember {
    [int]$Id
    $FullData

    [string]$TeamRole
    [string]$MemberId
    [string]$MemberName
    [bool]$AccountManager
    [bool]$Tech
    [bool]$Sales


    #region Initiators
    ########################################################################

    # empty initiator
    CwmCompanyTeamMember() {
    }

    ########################################################################
    #endregion Initiators
}
