# Puts the built extension and its installer into one folder (CI uploads it as "tanooki-auth-powertoys").
# Run after the Release build in .github/workflows/powertoys.yml.
param([Parameter(Mandatory)] [string] $Out)
$ErrorActionPreference = 'Stop'
$msix = Get-ChildItem -Recurse "$PSScriptRoot\TanookiAuthCommandPalette" -Filter *.msix | Sort-Object LastWriteTime | Select-Object -Last 1
if (!$msix) { throw 'No .msix found. Build TanookiAuthCommandPalette first (see .github/workflows/powertoys.yml).' }
Remove-Item -Recurse -Force $Out -ErrorAction SilentlyContinue
New-Item -ItemType Directory $Out | Out-Null
# A .msix is a zip: unpacked, Windows can install it from the folder without a signing certificate.
Copy-Item $msix.FullName "$Out\app.zip"
Expand-Archive "$Out\app.zip" "$Out\app"
Remove-Item "$Out\app.zip"
Copy-Item "$PSScriptRoot\package\*" $Out
Write-Host "Made $Out from $($msix.Name)"
