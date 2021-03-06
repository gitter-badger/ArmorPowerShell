function Get-ArmorNoun {
    <#
        .SYNOPSIS
        { required: high level overview }

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Name { required }
        Twitter: { optional }
        GitHub: { optional }
        Any other links you'd like here

        .PARAMETER Parameter
        { required: description of the specified input parameter's purpose }

        .INPUTS
        { required: .NET Framework object types that can be piped in and a description of the input objects }

        .OUTPUTS
        { required: .NET Framework object types that the cmdlet returns and a description of the returned objects }

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        {required: show one or more examples using the function}
    #>

    [CmdletBinding()]
    param (
        [String] $Param1,
        [String] $Param2,
        [String] $Param3,
        [String] $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        # The begin section is used to perform one-time loads of data necessary to carry out the function's purpose
        # If a command needs to be run with each iteration or pipeline input, place it in the process section

        # API data references the name of the function
        # For convenience, that name is saved here to $function
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        # Check to ensure that a session to the Armor cluster exists and load the needed header data for authentication
        Test-ArmorSession
    } # End of begin

    process {
        # Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
        Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )
        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $IDs

        $uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description

        $results = Expand-ArmorApiResult -Results $results -Location $resources.Location

        $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

        if ( $results.Count -eq 0 ) {
            Write-Host -Object 'Armor item not found.'
        }

        return $results
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
