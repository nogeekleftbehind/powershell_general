<#
.Synopsis
   Get-ServerLastLogon - Returns MachineName and LastLogon
.DESCRIPTION
   Script searches Active Directory for all 'Server' objects 
   Displays a list of the results
.EXAMPLE
   Get-ServerLastLogon
#>

# Find all servers in Active Directory
$dcs = Get-ADComputer -Filter { OperatingSystem -Like '*Server*' } -Properties OperatingSystem

# Check each server for last logon, display date and time
ForEach($dc in $dcs) { 
    Get-ADComputer $dc.Name -Properties lastlogontimestamp | 
    Select-Object @{n="Computer";e={$_.Name}}, @{Name="Lastlogon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}
}