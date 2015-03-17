<#
.Synopsis
   Get-DCTime - Compares time on AD Domain Controllers
.DESCRIPTION
   Scripts polls for AD for domain controllers, then polls each DC for current time.
   This script takes a while to run if you have a large number of DCs.
   Script requires the use of the Get-Time function
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

function Get-Time {
	<#
		.SYNOPSIS
			Gets the time of a windows server

		.DESCRIPTION
			Uses WMI to get the time of a remote server

		.PARAMETER  ServerName
			The Server to get the date and time from

		.EXAMPLE
			PS C:\> Get-Time localhost

		.EXAMPLE
			PS C:\> Get-Time server01.domain.local -Credential (Get-Credential)

	#>
	[CmdletBinding()]
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$ServerName,

		$Credential

	)
	try {
			If ($Credential) {
				$DT = Get-WmiObject -Class Win32_LocalTime -ComputerName $servername -Credential $Credential
			} Else {
				$DT = Get-WmiObject -Class Win32_LocalTime -ComputerName $servername
			}
	}
	catch {
		throw
	}

	$Times = New-Object PSObject -Property @{
		ServerName = $DT.__Server
		DateTime = (Get-Date -Day $DT.Day -Month $DT.Month -Year $DT.Year -Minute $DT.Minute -Hour $DT.Hour -Second $DT.Second)
	}
	$Times

}

#Example of using this function
$Servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows Server*"} | Sort-Object -Property @{Expression="Name";Descending=$False}

$Servers | Foreach {
	Get-Time $_.Name
}

# Get all DCs, load into variable $Servers

    $Servers = Get-ADDomainController -Filter *

# Loop through all DCs, poll each for current time, output to screen

foreach ($Server in $Servers)
{
    Get-Time $Server 
}
