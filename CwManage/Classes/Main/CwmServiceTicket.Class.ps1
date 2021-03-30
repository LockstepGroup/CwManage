class CwmServiceTicket {
    [int]$Id
    $FullData

    [string]$CompanyName
    [string]$Summary

    [int]$AgreementId
    [string]$AgreementName

    ##################################### Constructors #####################################
    # Constructor with no parameter
    CwmServiceTicket() {
    }
}