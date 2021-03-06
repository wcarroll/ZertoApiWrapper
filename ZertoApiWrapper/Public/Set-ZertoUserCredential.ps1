<# .ExternalHelp ./en-us/ZertoApiWrapper-help.xml #>
function Set-ZertoUserCredential {
    [cmdletbinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(
            HelpMessage = "PSCredential Object that contains the username and password for the updated credentials.",
            Mandatory
        )]
        [pscredential]$UserCredential
    )

    begin {

    }

    process {
        $uri = '/localsite/virtualizationsettings'
        $body = @{
            Credentials = @{
                UserName = $UserCredential.UserName
                Password = $UserCredential.GetNetworkCredential().Password
            }
        }
        if ( $PSCmdlet.ShouldProcess( $script:zvmServer, "Updating hypervisor service account credentials" )) {
            Invoke-ZertoRestRequest -uri $uri -Method PUT -body ($body | ConvertTo-Json)
        }
    }

    end {

    }
}
