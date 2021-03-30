class HelperWeb {
    static [string] createQueryString ([hashtable]$hashTable) {
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

    static [string] formatConditionValue ($value) {
        if ($value.GetType().Name -eq 'String') {
            $formatedValue = '"' + [System.Uri]::EscapeDataString($value) + '"'
            return $formatedValue
        } else {
            return $value
        }
    }

    static [string] createConditionString ([hashtable]$hashTable) {
        $i = 0
        $returnString = ""
        $ConditionRx = [regex] '(?<operator>[=!<>]+)(?<value>.+)'
        foreach ($hash in $hashTable.GetEnumerator()) {
            $ConditionMatch = $ConditionRx.Match($hash.Value)
            if ($ConditionMatch.Success) {
                $Operator = $ConditionMatch.Groups['operator'].Value
                $ConditionValue = $ConditionMatch.Groups['value'].Value
            } else {
                $Operator = '='
                $ConditionValue = $hash.Value
            }
            $i++
            if ($hash.Value.GetType().BaseType.Name -eq 'Array') {
                foreach ($v in $hash.Value) {
                    if ($returnString.Length -gt 0) {
                        $returnString += ' and '
                    }
                    $returnString += $hash.Name + $Operator + [HelperWeb]::formatConditionValue($ConditionValue)
                }
            } else {
                if ($returnString.Length -gt 0) {
                    $returnString += ' and '
                }
                $returnString += $hash.Name + $Operator + [HelperWeb]::formatConditionValue($ConditionValue)
            }
        }
        return $returnString
    }
}