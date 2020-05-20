class Agreement {
    [int]$AgreementId
    $FullData

    [string]$Name
    [string]$AgreementType
    [string]$AgreementTypeId
    [string]$CompanyName
    [string]$Status

    [datetime]$StartDate
    [datetime]$EndDate

    [string]$ApplicationUnit
    [decimal]$ApplicationLimit
    [string]$ApplicationCycle

    [bool]$IsOneTime

    [bool]$CarryOverUnused
    [int]$CarryOverExpireDays

    [bool]$ExpireWhenZero

    [decimal]$StartingBalance

    ##################################### Constructors #####################################
    # Constructor with no parameter
    Agreement() {
    }
}