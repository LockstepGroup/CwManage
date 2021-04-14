Class CwmServer {
    [string]$BaseFqdn = 'api-na.myconnectwise.net/v4_6_Release/apis/3.0'
    [string]$UriPath
    [string]$AuthString
    [string]$ClientId
    [string]$Company

    #region Tracking
    ########################################################################

    hidden [bool]$Connected
    [array]$UrlHistory
    [array]$RawQueryResultHistory
    [array]$ConditionHistory
    $LastError
    $LastResult

    ########################################################################
    #endregion Tracking

    # createQueryString
    [string] createQueryString ([hashtable]$hashTable) {
        $i = 0
        $queryString = "?"
        foreach ($hash in $hashTable.GetEnumerator()) {
            $i++
            $queryString += $hash.Name + "=" + $hash.Value
            if ($i -lt $HashTable.Count) {
                $queryString += "&"
            }
        }
        return $queryString
    }

    # formatConditionValue
    [string] formatConditionValue ($value) {
        if ($value.GetType().Name -eq 'String') {
            if ($value -match '\[.+\]') {
                $formatedValue = [System.Uri]::EscapeDataString($value)
            } else {
                $formatedValue = '"' + [System.Uri]::EscapeDataString($value) + '"'
            }
            return $formatedValue
        } else {
            return $value
        }
    }

    # createConditionString
    [string] createConditionString ([hashtable]$hashTable) {
        #$i = 0
        $returnString = ""
        $ConditionRx = [regex] '(?<operator>[=!<>]+|(like|contains)(?=\s))(?<value>.+)'
        foreach ($hash in $hashTable.GetEnumerator()) {
            $ConditionMatch = $ConditionRx.Match($hash.Value)
            if ($ConditionMatch.Success) {
                $Operator = $ConditionMatch.Groups['operator'].Value
                $ConditionValue = $ConditionMatch.Groups['value'].Value
            } else {
                $Operator = '='
                $ConditionValue = $hash.Value
            }

            # trim strings
            if ($ConditionValue.GetType().Name -eq 'string') {
                $ConditionValue = $ConditionValue.Trim()
            }

            if ($hash.Value.GetType().BaseType.Name -eq 'Array') {
                foreach ($v in $hash.Value) {
                    if ($returnString.Length -gt 0) {
                        $returnString += ' and '
                    }
                    $returnString += $hash.Name + $Operator + $this.formatConditionValue($ConditionValue)
                }
            } else {
                if ($returnString.Length -gt 0) {
                    $returnString += ' and '
                }

                # space out operators that aren't normal math operators
                if ($Operator -match '[a-zA-Z]') {
                    $Operator = ' ' + $Operator + ' '
                }

                $returnString += $hash.Name + $Operator + $this.formatConditionValue($ConditionValue)
            }
        }
        return $returnString
    }

    # Generate Api URL
    [String] getApiUrl() {
        if ($this.BaseFqdn) {
            $url = "https://" + $this.BaseFqdn + '/' + $this.UriPath
            return $url
        } else {
            return $null
        }
    }



    #region processQueryResult
    ########################################################################

    [psobject] processQueryResult ($unprocessedResult) {
        return $unprocessedResult
    }

    ########################################################################
    #endregion processQueryResult

    #region invokeApiQuery
    ########################################################################

    [psobject] invokeApiQuery([hashtable]$conditions, [hashtable]$queryParameters, [string]$method) {

        # Wrike uses the query string as a body attribute, keeping this function as is for now and just using an empty querystring
        $uri = $this.getApiUrl()

        # Populate Query/Url History
        #$QueryString = [HelperWeb]::createQueryString($QueryParams)
        $formattedConditionString = $this.createConditionString($conditions)
        $queryParameters.conditions = $formattedConditionString
        $fullUri = $uri + $this.createQueryString($queryParameters)
        $this.UrlHistory += $fullUri
        $this.ConditionHistory += $conditions

        # try query
        try {
            $QueryParams = @{}
            $QueryParams.Uri = $fullUri
            $QueryParams.Method = $method
            $QueryParams.ContentType = 'application/json; charset=utf-8'
            $QueryParams.Headers = @{
                'Authorization' = "Basic $($this.AuthString)"
                clientid        = $this.ClientId
            }

            Write-Verbose "Trying $FullUri"
            $rawResult = Invoke-RestMethod @QueryParams
        } catch {
            Throw $_
        }

        $this.RawQueryResultHistory += $rawResult
        $this.LastResult = $rawResult

        $proccessedResult = $this.processQueryResult($rawResult)

        return $proccessedResult
    }

    # with just a querystring
    [psobject] invokeApiQuery([hashtable]$conditions) {
        return $this.invokeApiQuery($conditions, 'GET')
    }

    # with just a method
    [psobject] invokeApiQuery([string]$method) {
        return $this.invokeApiQuery(@{}, $method)
    }

    # with no method or querystring specified
    [psobject] invokeApiQuery() {
        return $this.invokeApiQuery(@{}, 'GET')
    }

    ########################################################################
    #endregion invokeApiQuery

    #region Initiators
    ########################################################################

    # empty initiator
    CwmServer() {
    }

    ########################################################################
    #endregion Initiators
}
