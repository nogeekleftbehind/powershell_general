<#
.Synopsis
   Get-ServerLastLogon - Show last logon time and date for all servers
.DESCRIPTION
   Script searches Active Directory for all 'Server' objects
   Returns MachineName and LastLogon
   Outputs to screen
Long description
.EXAMPLE
   Get-ServerLastLogon
#>

# Find all Servers in Active Directory
$Servers = Get-ADComputer -Filter { OperatingSystem -Like '*Server*' } -Properties OperatingSystem

# Loop through all servers, display last logon time and date
foreach($Server in $Servers) 
{ 
    Get-ADComputer $Server.Name -Properties lastlogontimestamp | 
    Select-Object @{n="Computer";e={$_.Name}}, @{Name="Lastlogon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}
}
