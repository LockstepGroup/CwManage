---
external help file: CwManage-help.xml
Module Name: CwManage
online version:
schema: 2.0.0
---

# Get-CwmServiceTicket

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### NoId (Default)
```
Get-CwmServiceTicket [-Status <String[]>] [-NotStatus <String[]>] [-ServiceBoard <String>] [-Company <String>]
 [-PageSize <String>] [-AuthString <String>] [<CommonParameters>]
```

### Id
```
Get-CwmServiceTicket [-TicketNumber <Int32[]>] [-AuthString <String>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AuthString
{{Fill AuthString Description}}

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

### -Company
{{Fill Company Description}}

```yaml
Type: String
Parameter Sets: NoId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NotStatus
{{Fill NotStatus Description}}

```yaml
Type: String[]
Parameter Sets: NoId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
{{Fill PageSize Description}}

```yaml
Type: String
Parameter Sets: NoId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceBoard
{{Fill ServiceBoard Description}}

```yaml
Type: String
Parameter Sets: NoId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Status
{{Fill Status Description}}

```yaml
Type: String[]
Parameter Sets: NoId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TicketNumber
{{Fill TicketNumber Description}}

```yaml
Type: Int32[]
Parameter Sets: Id
Aliases: Id

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
