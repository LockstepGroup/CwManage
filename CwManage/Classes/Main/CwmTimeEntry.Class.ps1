class CwmTimeEntry {
    [int]$TimeEntryId
    $FullData

    [string]$CompanyName
    [string]$Member
    [string]$Notes
    [decimal]$ActualHours
    [datetime]$TimeStart

    [string]$TicketSummary

    ##################################### Constructors #####################################
    # Constructor with no parameter
    CwmTimeEntry() {
    }

    # Constructor with id
    CwmTimeEntry([int]$Id) {
        $this.TimeEntryId = $Id
    }
}