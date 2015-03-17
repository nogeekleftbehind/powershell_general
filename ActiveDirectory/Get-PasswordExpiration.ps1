<#
.Synopsis
   Get-PasswordExpiration - Show users with expiring passwords
.DESCRIPTION
   Polls Active Directory for a list of users whose passwords expire.
   Shows DisplayName, ExpiryDate, WhenCreated & LastLogonDate in a table
   Outputs to screen
.EXAMPLE
   Get-PasswordExpiration
#>

Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties DisplayName,WhenCreated,LastLogonDate,"msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "DisplayName",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}},WhenCreated,LastLogonDate 

 