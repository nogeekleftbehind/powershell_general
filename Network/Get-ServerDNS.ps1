<#
.SYNOPSIS
    Get-ServerDNS - Gathers DNS settings from computers.
.DESCRIPTION
    This script gathers DNS settings from the specified computer(s)
.NOTES
    File Name: Get-ServerDNS.ps1
    Author: Karl Mitschke
    Requires: Powershell V2
    Created:  05/12/2010
    Modified: 12/23/2011
.LINK
    "http://unlockpowershell.wordpress.com/2010/05/12/powershell-wmi-gather-dns-settings-for-all-servers-2/"
    "http://gallery.technet.microsoft.com/Gather-DNS-settings-from-fec23eaa"

.EXAMPLE
C:\PS>.\Get-ServerDNS.ps1
Description
-----------
Gathers DNS settings from the local computer.
.EXAMPLE
C:\PS>.\Get-ServerDNS.ps1 -Computer Exch2010
Description
-----------
Gathers DNS settings from the computer Exch2010.
.EXAMPLE
C:\PS> Get-ExchangeServer | Get-ServerDNS.ps1
Description
-----------
Gathers DNS settings on all Exchange servers.
.EXAMPLE
C:\PS> $cred = Get-Credential -Credential mitschke\karlm
C:\PS>.\Get-ServerDNS.ps1 -ComputerName (Get-Content -Path ..\Servers.txt) -Credential $cred
Description
-----------
Gathers DNS settings on all servers in the file Servers.txt.
.PARAMETER ComputerName
    The Computer(s) to Gather DNS settings from. If not specified, defaults to the local computer.
.PARAMETER Credential
    The Credential to use. If not specified, runs under the current security context.
#>

[CmdletBinding(SupportsShouldProcess=$false, ConfirmImpact='Medium')]
param (
[parameter(
Mandatory=$false,
ValueFromPipeline=$true)
]
[String[]]$ComputerName=$Env:ComputerName,
[Parameter(
Position = 1,
Mandatory = $false
)]
$Credential
)
BEGIN{
   #region PSBoundParameters modification
    if ($Credential -ne $null -and $Credential.GetType().Name -eq "String"){
        $PSBoundParameters.Remove("Credential") | Out-Null
        $PSBoundParameters.Add("Credential", (Get-Credential -Credential $Credential))
    }
    #endregion
    $AllServers = @()
    $ServerObj  = @()
    $Member = @{
        MemberType = "NoteProperty"
        Force = $true
    }
}
PROCESS{
    $PSBoundParameters.Remove("ComputerName") | Out-Null
    foreach ($StrComputer in $ComputerName){
        $NetItems = $null
        Write-Progress -Status "Working on $StrComputer" -Activity "Gathering Data"
        $ServerObj = New-Object psObject
        $ServerObj | Add-Member @Member -Name "Hostname" -Value $StrComputer
        $NetItems = @(Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'" -ComputerName $StrComputer @PSBoundParameters)
        $intRowNet = 0
        $ServerObj | Add-Member -MemberType NoteProperty -Name "NIC's" -Value $NetItems.Length -Force
        [STRING]$MACAddresses = @()
        [STRING]$IpAddresses = @()
        [STRING]$DNS = @()
        [STRING]$DNSSuffix = @()
        foreach ($objItem in $NetItems){
            if ($objItem.IPAddress.Count -gt 1){
                $TempIpAdderesses = [STRING]$objItem.IPAddress
                $TempIpAdderesses  = $TempIpAdderesses.Trim().Replace(" ", " ; ")
                $IpAddresses += $TempIpAdderesses
            }
            else{
                $IpAddresses += $objItem.IPAddress +"; "
            }
            if ($objItem.{MacAddress}.Count -gt 1){
                $TempMACAddresses = [STRING]$objItem.MACAddress
                $TempMACAddresses = $TempMACAddresses.Replace(" ", " ; ")
                $MACAddresses += $TempMACAddresses +"; "
            }
            else{
                $MACAddresses += $objItem.MACAddress +"; "
            }
            if ($objItem.{DNSServerSearchOrder}.Count -gt 1){
                $TempDNSAddresses = [STRING]$objItem.DNSServerSearchOrder
                $TempDNSAddresses = $TempDNSAddresses.Replace(" ", " ; ")
                $DNS += $TempDNSAddresses +"; "
            }
            else{
                $DNS += $objItem.{DNSServerSearchOrder} +"; "
            }
            if ($objItem.DNSDomainSuffixSearchOrder.Count -gt 1){
                $TempDNSSuffixes = [STRING]$objItem.DNSDomainSuffixSearchOrder
                $TempDNSSuffixes = $TempDNSSuffixes.Replace(" ", " ; ")
                $DNSSuffix += $TempDNSSuffixes +"; "
                }
            else{
                $DNSSuffix += $objItem.DNSDomainSuffixSearchOrder +"; "
                }
                $SubNet = [STRING]$objItem.IPSubnet[0]
            $intRowNet = $intRowNet + 1
        }
        $ServerObj | Add-Member @Member -Name "IP Address" -Value $IpAddresses.substring(0,$ipaddresses.LastIndexOf(";"))
        $ServerObj | Add-Member @Member -Name "IP Subnet" -Value $SubNet
        $ServerObj | Add-Member @Member -Name "MAC Address" -Value $MACAddresses.substring(0,$MACAddresses.LastIndexOf(";"))
        $ServerObj | Add-Member @Member -Name "DNS" -Value $DNS
        $ServerObj | Add-Member @Member -Name "DNS Suffix Search Order" -Value $DNSSuffix
        $ServerObj | Add-Member @Member -Name "DNS Enabled For Wins" -Value $objItem.DNSEnabledForWINSResolution
        $ServerObj | Add-Member @Member -Name "Domain DNS Registration Enabled" -Value $objItem.DomainDNSRegistrationEnabled
        $ServerObj | Add-Member @Member -Name "Full DNS Registration Enabled" -Value $objItem.FullDNSRegistrationEnabled
        $ServerObj | Add-Member @Member -Name "DHCP Enabled" -Value $objItem.DHCPEnabled
        $ServerObj | Add-Member @Member -Name "DHCP Lease Obtained" -Value $objItem.DHCPLeaseObtained
        $ServerObj | Add-Member @Member -Name "DHCP Lease Expires" -Value $objItem.DHCPLeaseExpires
        $AllServers += $ServerObj
    }
}
END{
    Write-Output -InputObject $AllServers
}