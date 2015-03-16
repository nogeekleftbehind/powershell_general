# Added to GitHub
# Testing GitHub edit in PowerShell ISE via web page

$VMs = Get-VM
Foreach ($VM in $VMs)
{
  $HardDrives = $VM.HardDrives
  Foreach ($HardDrive in $HardDrives)
  {
    $HardDrive.path | Get-VHD
  }
}