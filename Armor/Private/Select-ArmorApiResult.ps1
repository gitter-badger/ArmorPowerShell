function Select-ArmorApiResult {
    <#
		.SYNOPSIS
		The Select-ArmorApiResult function is used to filter data that has been returned from an endpoint for specific objects important to the user.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Results
		The formatted API response contents.

		.PARAMETER Filter
		The list of parameters that the user can use to filter response data. 
		Each key is the parameter name without the "$" and each value corresponds to the response data's key.

		.INPUTS
		System.Management.Automation.PSCustomObject

		.OUTPUTS
		System.Management.Automation.PSCustomObject

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
        [Parameter( Position = 0, ValueFromPipeline = $true )]
        [PSCustomObject[]] $Results = @(),
        [Parameter( Position = 1 )]
        [ValidateNotNull()]
        [Hashtable] $Filter = $null
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        if ( $Results.Count -eq 0 -or $Filter.Keys.Count -eq 0 ) {
            return $Results
        }

        $return = $Results.Clone()

        Write-Verbose -Message 'Filter the results.'

        foreach ( $filterKey in $Filter.Keys ) {
            if ( ( Get-Variable -Name $filterKey -ErrorAction 'SilentlyContinue' ).Value -ne $null ) {
                Write-Verbose -Message ( 'Filter match = {0}' -f $filterKey )

                $filterKeyValue = ( Get-Variable -Name $filterKey ).Value

                # For when a location is one layer deep
                if ( $filterKeyValue -and $Filter[$filterKey].Split( '.' ).Count -eq 1 ) {
                    # The $filterKeyValue check assumes that not all filters will be used in each call
                    # If it does exist, the results are filtered using the $filterKeyValue's value against the $Filter[$filterKey]'s key name
                    $return = $return.Where( { $_.( $Filter[$filterKey] ) -like $filterKeyValue } )
                }
                # For when a location is two layers deep
                elseif ( $filterKeyValue -and $Filter[$filterKey].Split( '.' ).Count -eq 2 ) {
                    # The $filterKeyValue check assumes that not all filters will be used in each call
                    # If it does exist, the results are filtered using the $filterKeyValue's value against the $Filter[$filterKey]'s key name
                    $return = $return.Where( { $_.( $Filter[$filterKey].Split( '.' )[0] ).( $Filter[$filterKey].Split( '.' )[-1] ) -like $filterKeyValue } )
                }
            }
        }

        return $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
