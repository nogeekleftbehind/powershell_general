<#
.Synopsis
   Show-FullPath - Enables Full Path in the title bar
.DESCRIPTION
   Show Windows Explorer Full Path in the Windows Explorer title bar
.EXAMPLE
   Show-FullPath
#>

    Set-ItemProperty -Name FullPath -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\" -Value "1"

<#
	0 = Show Folder Name Only
	1 = Show Full Path in Title Bar
#>