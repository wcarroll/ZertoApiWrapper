#Requires -Modules Pester
$global:here = (Split-Path -Parent $PSCommandPath)
$global:function = ((Split-Path -leaf $PSCommandPath).Split('.'))[0]

Describe $global:function -Tag 'Unit', 'Source', 'Built' {

    Context "$($global:function)::Parameter Unit Tests" {
        It "Does not take any parameters" {
            (Get-Command disconnect-zertoserver).parameters.count | Should -BeExactly 11
        }
    }

    Context "$($global:function)::Function Unit Tests" {
        InModuleScope -ModuleName ZertoApiWrapper {
            Mock -ModuleName ZertoApiWrapper -CommandName Invoke-ZertoRestRequest {
                # Attempted to Mock this per the Mock Below and it blew up. Auth Headers Returns a Dictionary
                # and does not index the same way when imported from a JSON file. Need addtional investigation.
                $xZertoSession = @("e34da0b0-4bc2-4cda-b316-0384e35bdca5")
                $Headers = @{'x-zerto-session' = $xZertoSession }
                $results = @{'Headers' = $Headers }
                return $results
            }

            Mock -ModuleName ZertoApiWrapper -CommandName Get-ZertoLocalSite {
                return (Get-Content -Path "$global:here\Mocks\LocalSiteInfo.json" -Raw | ConvertFrom-Json)
            }

            BeforeAll {
                Connect-ZertoServer
            }

            It "Does not return anything" {
                Disconnect-ZertoServer | Should -BeNullOrEmpty
            }
        }
    }
}

Remove-Variable -Name function -Scope Global
Remove-Variable -Name here -Scope Global
