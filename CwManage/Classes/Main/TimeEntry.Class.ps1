class TimeEntry {
    [int]$TimeEntryId
    $FullData

    [string]$Name

    ##################################### Constructors #####################################
    # Constructor with no parameter
    TimeEntry() {
    }

    # Constructor with id
    TimeEntry([int]$Id) {
        $this.TimeEntryId = $Id
    }
}