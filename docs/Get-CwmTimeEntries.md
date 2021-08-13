---
external help file: CwManage-help.xml
Module Name: cwmanage
online version:
schema: 2.0.0
---

# Get-CwmTimeEntries

## SYNOPSIS
Retrieves Time Entries from ConnectWise Manage.

## SYNTAX

```
Get-CwmTimeEntries [[-AgreementId] <Int32>] [[-Member] <String[]>] [-PageSize <String>]
 [[-AuthString] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Time Entries from ConnectWise Manage. Can specify to return only entries for Member(s) of Argreement Id.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CwmTimeEntries -Member 'tstark','bbanner'
```

Returns first 1000 Time Entries for users tstark and bbanner.

### Example 2
```powershell
PS C:\> $Agreement = Get-CwmAgreement 1
PS C:\> $Agreement | Get-CwmTimeEntries -Member 'tstark','bbanner' -PageSize 10
```

Returns first 10 Time Entries for users tstark and bbanner applied towards any agreement for Company with Id of 1.

## PARAMETERS

### -AgreementId
Agreement Id Number (use Get-CwmAgreement to obtain them)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AuthString
Authstring created with Get-CwmAuthString, will default to $global:CwAuthString

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Member
Member identifier

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Number of results to return

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
