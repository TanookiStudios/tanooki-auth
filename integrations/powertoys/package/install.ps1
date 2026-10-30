# Installs Tanooki Auth for PowerToys Command Palette from this folder. Started by install.cmd.
$ErrorActionPreference = 'Stop'
$dev = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue
if ($dev.AllowDevelopmentWithoutDevLicense -ne 1) {
  Write-Host ''
  Write-Host 'Developer Mode is off, so Windows won''t install this yet.'
  Write-Host 'Turn it on: Start > Settings > System > Advanced (called "For developers" on some versions),'
  Write-Host 'switch "Developer Mode" on, click Yes, then run install.cmd again.'
  exit 1
}
Add-AppxPackage -Register "$PSScriptRoot\app\AppxManifest.xml" -ForceApplicationShutdown -ForceUpdateFromAnyVersion
Write-Host ''
Write-Host 'Installed. Open Command Palette (Windows key + Alt + Space), type Reload, pick'
Write-Host '"Reload Command Palette extensions", then type Tanooki.'
exit 0
