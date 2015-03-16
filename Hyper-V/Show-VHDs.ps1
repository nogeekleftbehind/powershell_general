$VMs = Get-VM
Foreach ($VM in $VMs)
{
  $HardDrives = $VM.HardDrives
  Foreach ($HardDrive in $HardDrives)
  {
    $HardDrive.path | Get-VHD
  }
}