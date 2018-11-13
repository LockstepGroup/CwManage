class Opportunity {
    [int]$OpportunityId
    $FullData

    [string]$Summary
    [string]$Status
    [string]$Company
    [string]$ContactName
    [string]$City
    [string]$State

    [string]$NextStep
    [datetime]$CloseDate
    [decimal]$Margin
    [int]$Age
    [decimal]$Revenue
    [decimal]$Expected
    [decimal]$Recurring
    [decimal]$Won
    [decimal]$Open
    [decimal]$Lost
    [decimal]$Time
    [int]$Agreement
    [decimal]$Product
    [decimal]$Service
    [decimal]$Other

    [string]$Stage
    [int]$ProbPercentage
    [string]$Rating

    [string]$SalesRep
    [string]$InsideSales
    [string]$PreSalesEngineer
    [string]$BusinessDevelopment

    [string]$Type
    [string]$Department
    [string]$Campaign
    [string]$Location
    [string]$Site
    [string]$Territory

    [bool]$Converted
    [bool]$NewLogo
    [bool]$SpiffEligible


    ##################################### Constructors #####################################
    # Constructor with no parameter
    Opportunity() {
    }
}