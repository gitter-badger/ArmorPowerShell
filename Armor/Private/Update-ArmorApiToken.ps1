function Update-ArmorApiToken {
    <#
        .SYNOPSIS
        Reissues an authentication token if requested prior to session expiration.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .PARAMETER Token
        The authorization token.

        .PARAMETER ApiVersion
        The API version.  The default value is $Global:ArmorSession.ApiVersion.

        .INPUTS
        System.String

        .OUTPUTS
        None

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        Update-ArmorApiToken -Token 2261bac252204c2ea93ed32ea1ffd3ab -ApiVersion 'v1.0'
    #>

    [CmdletBinding()]
    param (
        [Parameter( Position = 0, ValueFromPipeline = $true )]
        [ValidateNotNullorEmpty()]
        [String] $Token = $Global:ArmorSession.GetToken(),
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0' )]
        [String] $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )
        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri

        $body = Format-ArmorApiJsonRequestBody -BodyKeys $resources.Body.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description

        $Global:ArmorSession.Authorize( $results.Access_Token, $results.Expires_In )
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
