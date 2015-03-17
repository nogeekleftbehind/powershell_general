<#
.Synopsis
   Show-FileExtensions - Shows file extensions in Windows Explorer
.DESCRIPTION
   Changes the registry value to show hidden file extensions in Windows Explorer
.EXAMPLE
   Show-FileExtensions
#>

	Set-ItemProperty -Name HideFileExt -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Value "0"
<#
	0 = Show File Extensions
	1 = Hide File Extensions
#>