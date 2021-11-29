Class CwmContact {
    [int]$Id
    $FullData

    [string]$FirstName
    [string]$LastName
    [string]$CompanyName
    [string]$EmailAddress
    [string]$PhoneNumber

    [bool]$Active = $true

    #region Initiators
    ########################################################################

    # empty initiator
    CwmContact() {
    }

    ########################################################################
    #endregion Initiators
}
