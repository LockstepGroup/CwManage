---
external help file: CwManage-help.xml
Module Name: cwmanage
online version:
schema: 2.0.0
---

# Invoke-CwmApiCall

## SYNOPSIS
Underlying Cmdlet used to create all api calls to ConnectWise Manage.

## SYNTAX

```
Invoke-CwmApiCall [-Uri] <String> [-QueryParams <Hashtable>] [-Conditions <Hashtable>] [-Method <String>]
 [-Body <Hashtable>] [[-AuthString] <String>] [-ClientId <String>] [<CommonParameters>]
```

## DESCRIPTION
Underlying Cmdlet used to create all api calls to ConnectWise Manage. Can be used for API calls lacking a supporting Cmdlet.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-CwmApiCall -Uri https://example.connectwise.com/v4_6_release/apis/3.0/service/tickets -Method 'GET'
```

Returns the first 25 (default pagesize for api calls) service tickets.

### Example 2
```powershell
PS C:\> Invoke-CwmApiCall -Uri https://example.connectwise.com/v4_6_release/apis/3.0/service/tickets -Method 'GET' -QueryParams @{ 'pageSize' = 10 } -QueryParams = @{ 'company/name' = 'My Example Company" }
```

Returns the first 10 service tickets for My Example Company.

## PARAMETERS

### -AuthString
{{Fill AuthString Description}}

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

### -Uri
{{Fill Uri Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
{{Fill Body Description}}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Conditions
{{Fill Conditions Description}}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
{{Fill Method Description}}

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

### -QueryParams
{{Fill QueryParams Description}}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
{{ Fill ClientId Description }}

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
