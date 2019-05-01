if (-not $ENV:BHProjectPath) {
    Set-BuildEnvironment -Path $PSScriptRoot\..
}
Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) -Force


InModuleScope $ENV:BHProjectName {
    $PSVersion = $PSVersionTable.PSVersion.Major
    $ProjectRoot = $ENV:BHProjectPath

    $Verbose = @{}
    if ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {
        $Verbose.add("Verbose", $True)
    }

    $CwCompany = 'mycompany'
    $CwPublicKey = 'mypublickey'
    $CwPrivateKey = 'myprivatekey'
    $MyAuthString = 'bXljb21wYW55K215cHVibGlja2V5Om15cHJpdmF0ZWtleQ=='

    Describe "New-CwmAuthString" {
        It "Should return correctly encoded auth string" {
            New-CwmAuthString -CwCompany $CwCompany -CwPublicKey $CwPublicKey -CwPrivateKey $CwPrivateKey | Should be $MyAuthString
        }
    }

    Assert-VerifiableMock
}