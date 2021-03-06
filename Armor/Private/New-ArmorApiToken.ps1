function New-ArmorApiToken {
    <#
        .SYNOPSIS
        Creates an authentication token from an authorization code.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .PARAMETER Code
        The temporary authorization code to redeem for a token.

        .PARAMETER GrantType
        The type of permission.

        .PARAMETER ApiVersion
        The API version.

        .INPUTS
        System.String

        .OUTPUTS
        System.Management.Automation.PSCustomObject

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        New-ArmorApiToken -Code 'HJTX3gAAAAN2q1UP7cvFtOh1qffrfWIpKetdnIgvOfpJRSC5W7b3vVqMBn8pZHtRY8I4nLRzW95gdWPdRMVUrgsnJ2mwqB8kgxOu8lhH1LOggfwrRCvxLGvGmwET59gIzJ60rxpEdM0dTLw58kNnWVbaQI1NmPQJwjvD/1RIPTnOL5d+z29wyJ/BI/POlPKNlVfHsJGYJl8ql0/3D3czNGhXCqfV20Uj0r8EX7zsQz/9t1YCqKKj9OpPv3sypXS6h4hNb/v4yLD33G+EnwOajJQ62sA='
    #>

    [CmdletBinding()]
    param (
        [Parameter( ValueFromPipeline = $true, Position = 0 )]
        [ValidateNotNullorEmpty()]
        [String] $Code = $null,
        [Parameter( Position = 1 )]
        [ValidateSet( 'authorization_code' )]
        [String] $GrantType = 'authorization_code',
        [Parameter( Position = 2 )]
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

        $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

        return $results
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
