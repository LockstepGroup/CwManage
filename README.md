# CwManage

CwManage is a PowerShell wrapper for the ConnectWise Manage API. Right now, only hosted instances are of Manage are supported.

## Installation

``` powershell
Install-Module CwManage
```

## Usage

CwManage requires a public/private keypair for a valid ConnectWise Manage Account. These can be found under the API Keys tab under "My Account"

``` powershell
# Create your AuthString
$AuthString = New-CwmAuthString -CwCompany 'mycompany' -CwPublicKey 'mypublickey' -CwPrivateKey 'myprivatekey'
$Companies = Get-CwmCompany -AuthString $AuthString
```

`New-CwmAuthString` will default to global variables `CwCompany`, `CwPublicKey`, `CwPrivateKey`, if not explicitly specified in the cmdlet. It also saves the returned AuthString to the global variable `CwAuthString` that all subsequent cmdlets will default to if not explicitly specified.

If you need to execute an api call not supported by an existsing cmdlet, you can use the generic cmdlet `Invoke-CwmApiCall` with a properly formatted uri per the [developer docs](https://developer.connectwise.com/Manage/Developer_Guide).