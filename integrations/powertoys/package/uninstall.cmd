@echo off
rem Double-click to remove Tanooki Auth for PowerToys.
powershell -NoProfile -Command "Get-AppxPackage TanookiStudios.TanookiAuthCommandPalette | Remove-AppxPackage; Write-Host 'Removed.'"
pause
