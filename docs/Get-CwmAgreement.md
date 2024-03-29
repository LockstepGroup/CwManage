---
external help file: CwManage-help.xml
Module Name: CwManage
online version:
schema: 2.0.0
---

# Get-CwmAgreement

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### NoId
```
Get-CwmAgreement [[-CompanyId] <Int32>] [-OpportunityId <Int32>] [-AuthString <String>] [-ShowAll]
 [-Status <String>] [-PageSize <String>] [<CommonParameters>]
```

### Id
```
Get-CwmAgreement [-AgreementId <Int32>] [-AuthString <String>] [<CommonParameters>]
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

### -CompanyId
{{Fill CompanyId Description}}

```yaml
Type: Int32
Parameter Sets: NoId
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ShowAll
{{Fill ShowAll Description}}

```yaml
Type: SwitchParameter
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

### -AgreementId
{{ Fill AgreementId Description }}

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpportunityId
{{ Fill OpportunityId Description }}

```yaml
Type: Int32
Parameter Sets: NoId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
{{ Fill Status Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
