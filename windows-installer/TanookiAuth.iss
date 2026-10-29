; Inno Setup script for the Windows installer. Built by .github/workflows/windows.yml.
#define AppVersion GetEnv("APP_VERSION")
[Setup]
AppId={{6E2F3C7A-8C1B-4B7E-9C55-2A4D7F1E9B21}
AppName=Tanooki Auth
AppVersion={#AppVersion}
AppPublisher=Tanooki Studios
AppPublisherURL=https://tanookistudios.com
DefaultDirName={autopf}\Tanooki Auth
DefaultGroupName=Tanooki Auth
UninstallDisplayIcon={app}\TanookiAuth.exe
OutputDir=..\dist
OutputBaseFilename=Tanooki-Auth-{#AppVersion}-windows-setup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible
SetupIconFile=..\app\windows\runner\resources\app_icon.ico
PrivilegesRequiredOverridesAllowed=dialog

[Files]
Source: "..\app\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\Tanooki Auth"; Filename: "{app}\TanookiAuth.exe"
Name: "{autodesktop}\Tanooki Auth"; Filename: "{app}\TanookiAuth.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; Flags: unchecked

[Run]
Filename: "{app}\TanookiAuth.exe"; Description: "Open Tanooki Auth"; Flags: nowait postinstall skipifsilent
