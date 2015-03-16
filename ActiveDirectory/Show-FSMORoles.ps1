<#
.Synopsis
   Show-FSMORoles - Show all five FSMO role holders
.DESCRIPTION
   Polls local computer for domain information.
   Uses that domain info to display current FSMO role holders.
.EXAMPLE
   Show-FSMORoles
#>

# Get current domain 
$Domain = Get-ADDomain

# Get DNSRoot of current domain
$DNSRoot = $Domain.DNSRoot

# Use variables above to display all 5 FSMO role holders
Netdom query /domain:$DNSRoot FSMO