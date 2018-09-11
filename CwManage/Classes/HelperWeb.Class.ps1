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

    static [string] createConditionString ([hashtable]$hashTable) {
        $i = 0
        $returnString = ""
        foreach ($hash in $hashTable.GetEnumerator()) {
            $i++
            if ($hash.Value.GetType().BaseType.Name -eq 'Array') {
                foreach ($v in $hash.Value) {
                    if ($returnString.Length -gt 0) {
                        $returnString += ' and '
                    }
                    $returnString += $hash.Name + '="' + $v + '"'
                }
            } else {
                if ($returnString.Length -gt 0) {
                    $returnString += ' and '
                }
                if ($hash.Value.GetType().Name -eq 'Boolean') {
                    $returnString += $hash.Name + '=' + $hash.Value + ''
                } else {
                    $returnString += $hash.Name + '="' + $hash.Value + '"'
                }
            }
        }
        return $returnString
    }
}