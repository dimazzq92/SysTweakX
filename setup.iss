[Setup]
AppName=SysTweakX
AppVersion=2.1
DefaultDirName={tmp}\SysTweakX
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableFinishedPage=yes
DisableWelcomePage=yes
Uninstallable=no
PrivilegesRequired=admin
OutputDir=.
OutputBaseFilename=SysTweakX
SetupIconFile=Work\setup.exe
Compression=lzma2/max
SolidCompression=yes
DisableWindow=yes

[Files]
Source: "*"; DestDir: "{app}"; Excludes: ".git\*,.github\*,setup.iss,SysTweakX.exe"; Flags: ignoreversion recursesubdirs

[Run]
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -WindowStyle Hidden -File ""{app}\GUI.ps1"""; Flags: nowait runhidden
