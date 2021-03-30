---
external help file: CwManage-help.xml
Module Name: CwManage
online version:
schema: 2.0.0
---

# New-CwmAuthString

## SYNOPSIS
Creates base64 string needed for APi Call Authorization Token.

## SYNTAX

```
New-CwmAuthString [[-CwCompany] <String>] [[-CwPublicKey] <String>] [[-CwPrivateKey] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates base64 string needed for APi Call Authorization Token. Value can be passed to other other cmdlets, but is also stored in global variable CwAuthString

## EXAMPLES

### Example 1
```powershell
PS C:\> $AuthString = New-CwmAuthString -CwCompany 'mycompany' -CwPublicKey 'mypublickey' -CwPrivateKey 'myprivatekey'
PS C:\> $Companies = Get-CwmCompany -AuthString $AuthString
```

Creates AuthString and uses it to query all Companies.

## PARAMETERS

### -CwCompany
ConnectWise Manage Company Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CwPrivateKey
ConnectWise Manage Private API Key

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

### -CwPublicKey
ConnectWise Manage Public API Key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### String
## NOTES

## RELATED LINKS
