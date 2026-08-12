param(
    [switch]$ShowReboot,
    [string]$Lang
)

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$registryPath = "HKCU:\Console\%%Startup"
$keys = @{
    "DelegationConsole"  = "{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}"
    "DelegationTerminal" = "{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}"
}

if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

foreach ($name in $keys.Keys) {
    Set-ItemProperty -Path $registryPath -Name $name -Value $keys[$name] -Type String -Force
}
# ================= РџРЈРўР =================
$batPath = Join-Path $PSScriptRoot "SysTweakX.bat"
$workDir = Join-Path $PSScriptRoot "Work"

# ================= LOCALIZATION =================
if ([string]::IsNullOrEmpty($Lang)) {
    $global:Lang = if ((Get-UICulture).TwoLetterISOLanguageName -eq "ru") { "RU" } else { "EN" }
} else {
    $global:Lang = $Lang
}

$loc = @{
    "RU" = @{
        "RebootTitle" = "РќР°СЃС‚СЂРѕР№РєР° Р·Р°РІРµСЂС€РµРЅР°!`n`nРџРµСЂРµР·Р°РіСЂСѓР·РёС‚СЊ РџРљ?"
        "Yes" = "Р”Рђ"
        "No" = "РќР•Рў"
        "Optimize" = "РћРџРўРРњРР—РР РћР’РђРўР¬"
        "LangToggle" = "EN"
        
        "Sec_Cleanup" = "РћС‡РёСЃС‚РєР°"
        "Twk_Updates" = "РЈРґР°Р»РёС‚СЊ С„Р°Р№Р»С‹ РѕР±РЅРѕРІР»РµРЅРёР№"
        "Twk_StoreCache" = "РЈРґР°Р»РёС‚СЊ РєСЌС€ Windows Store"
        "Twk_ExplorerCache" = "РЈРґР°Р»РёС‚СЊ РєСЌС€ РџСЂРѕРІРѕРґРЅРёРєР°"
        "Twk_WinSxS" = "РћС‡РёСЃС‚РёС‚СЊ С…СЂР°РЅРёР»РёС‰Рµ WinSxS"
        "Twk_JunkFolders" = "РЈРґР°Р»РёС‚СЊ Р»РёС€РЅРёРµ РїР°РїРєРё РЅР° РґРёСЃРєРµ C:"
        "Twk_OldDrivers" = "РЈРґР°Р»РёС‚СЊ СЃС‚Р°СЂС‹Рµ РґСЂР°Р№РІРµСЂР°"
        "Twk_ShellBags" = "РЈРґР°Р»РёС‚СЊ ShellBags"
        
        "Sec_Preinstalled" = "РџСЂРµРґСѓСЃС‚Р°РЅРѕРІР»РµРЅРЅС‹Рµ РїСЂРёР»РѕР¶РµРЅРёСЏ"
        "Twk_UWP" = "РЈРґР°Р»РёС‚СЊ РІСЃРµ UWP-РїСЂРёР»РѕР¶РµРЅРёСЏ"
        "Twk_OneDrive" = "РЈРґР°Р»РёС‚СЊ OneDrive"
        "Twk_RemoteAssist" = "РЈРґР°Р»РёС‚СЊ РџРѕРјРѕС‰РЅРёРєР° РїРѕ СѓРґР°Р»РµРЅРЅРѕРјСѓ РїРѕРґРєР»СЋС‡РµРЅРёСЋ"
        "Twk_StartMenu" = "РЈРґР°Р»РёС‚СЊ Р»РёС€РЅРёРµ РїР°РїРєРё РїСЂРёР»РѕР¶РµРЅРёР№ РІ РџСѓСЃРєРµ"
        
        "Sec_Edge" = "Р‘СЂР°СѓР·РµСЂ Edge Рё WebView2"
        "Twk_Edge" = "РЈРґР°Р»РёС‚СЊ Microsoft Edge"
        "Twk_WebView" = "РЈРґР°Р»РёС‚СЊ Edge WebView2"
        
        "Sec_Defender" = "Р—Р°С‰РёС‚РЅРёРє Windows"
        "Twk_Defender" = "РЈРґР°Р»РёС‚СЊ Р—Р°С‰РёС‚РЅРёРє Windows (DefenderKiller)"
        
        "Sec_Components" = "РљРѕРјРїРѕРЅРµРЅС‚С‹ Windows"
        "Twk_Components" = "РЈРґР°Р»РёС‚СЊ РІСЃРµ РґРѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ РєРѕРјРїРѕРЅРµРЅС‚С‹"
        
        "Sec_Tasks" = "РџР»Р°РЅРёСЂРѕРІС‰РёРє Р·Р°РґР°С‡"
        "Twk_Tasks" = "РћС‚РєР»СЋС‡РёС‚СЊ Р·Р°РґР°С‡Рё С‚РµР»РµРјРµС‚СЂРёРё Рё РїСЂРѕРІРµСЂРѕРє"
        
        "Sec_OptParams" = "РћРїС‚РёРјРёР·Р°С†РёСЏ РїР°СЂР°РјРµС‚СЂРѕРІ"
        "Twk_Hibernate" = "РћС‚РєР»СЋС‡РёС‚СЊ Р“РёР±РµСЂРЅР°С†РёСЋ"
        "Twk_ResStorage" = "РћС‚РєР»СЋС‡РёС‚СЊ Р—Р°СЂРµР·РµСЂРІРёСЂРѕРІР°РЅРЅРѕРµ С…СЂР°РЅРёР»РёС‰Рµ"
        "Twk_RestorePts" = "РћС‚РєР»СЋС‡РёС‚СЊ РўРѕС‡РєРё РІРѕСЃСЃС‚Р°РЅРѕРІР»РµРЅРёСЏ"
        "Twk_DelayedSvc" = "РћС‚Р»РѕР¶РµРЅРЅС‹Р№ Р·Р°РїСѓСЃРє Р°РІС‚РѕРјР°С‚РёС‡РµСЃРєРёС… СЃР»СѓР¶Р±"
        "Twk_SysLog" = "РњРёРЅРёРјРёР·РёСЂРѕРІР°С‚СЊ СЃРёСЃС‚РµРјРЅС‹Рµ РѕС‚С‡РµС‚С‹"
        "Twk_BoostIcon" = "РЈРІРµР»РёС‡РёС‚СЊ РєСЌС€ РёРєРѕРЅРѕРє"
        "Twk_SvcSplit" = "РЈРІРµР»РёС‡РёС‚СЊ РїРѕСЂРѕРі СЂР°Р·РґРµР»РµРЅРёСЏ SVC"
        "Twk_FastFolder" = "РЈСЃРєРѕСЂРёС‚СЊ РѕС‚РєСЂС‹С‚РёРµ РїР°РїРѕРє"
        "Twk_DisableVBS" = "РћС‚РєР»СЋС‡РёС‚СЊ VBS Рё HVCI"
        "Twk_GameDVR" = "РћС‚РєР»СЋС‡РёС‚СЊ GameDVR"
        "Twk_UltPerf" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ СЃС…РµРјСѓ РїРёС‚Р°РЅРёСЏ РњР°РєСЃРёРјР°Р»СЊРЅР°СЏ РїСЂРѕРёР·РІРѕРґРёС‚РµР»СЊРЅРѕСЃС‚СЊ"
        "Twk_Resume" = "РћС‚РєР»СЋС‡РёС‚СЊ С„СѓРЅРєС†РёСЋ Р’РѕР·РѕР±РЅРѕРІРёС‚СЊ"
        
        "Sec_WinUpdate" = "Р¦РµРЅС‚СЂ РѕР±РЅРѕРІР»РµРЅРёСЏ Windows"
        "Twk_WUDrivers" = "Р—Р°РїСЂРµС‚РёС‚СЊ СѓСЃС‚Р°РЅРѕРІРєСѓ РґСЂР°Р№РІРµСЂРѕРІ РёР· Р¦Рћ"
        "Twk_DefUpdates" = "Р—Р°РїСЂРµС‚РёС‚СЊ РѕР±РЅРѕРІР»РµРЅРёСЏ СѓРґР°Р»РµРЅРёСЏ РІСЂРµРґРѕРЅРѕСЃРЅС‹С… РїСЂРѕРіСЂР°РјРј"
        "Twk_PauseUpd" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ РїР°СѓР·Сѓ РѕР±РЅРѕРІР»РµРЅРёР№ РґРѕ 07.07.2077"
        "Twk_NoAutoUpd" = "Р—Р°РїСЂРµС‚РёС‚СЊ Р°РІС‚РѕРјР°С‚РёС‡РµСЃРєРёРµ РѕР±РЅРѕРІР»РµРЅРёСЏ"
        
        "Sec_Useful" = "РџРѕР»РµР·РЅС‹Рµ С‚РІРёРєРё"
        "Twk_UAC" = "РћС‚РєР»СЋС‡РёС‚СЊ UAC"
        "Twk_Admin" = "РЎРґРµР»Р°С‚СЊ СѓС‡РµС‚РЅСѓСЋ Р·Р°РїРёСЃСЊ РђРґРјРёРЅРёСЃС‚СЂР°С‚РёРІРЅРѕР№"
        "Twk_Region" = "РЎРЅСЏС‚СЊ СЂРµРіРёРѕРЅР°Р»СЊРЅС‹Рµ РѕРіСЂР°РЅРёС‡РµРЅРёСЏ"
        "Twk_KillFreeze" = "РџСЂРёРЅСѓРґРёС‚РµР»СЊРЅРѕ Р·Р°РІРµСЂС€Р°С‚СЊ РїСЂРѕРіСЂР°РјРјС‹ РїСЂРё Р·Р°РІРёСЃР°РЅРёРё"
        "Twk_Remote" = "РћС‚РєР»СЋС‡РёС‚СЊ РЈРґР°Р»РµРЅРЅС‹Р№ РїРѕРјРѕС‰РЅРёРє"
        "Twk_Sticky" = "РћС‚РєР»СЋС‡РёС‚СЊ Р·Р°Р»РёРїР°РЅРёРµ РєР»Р°РІРёС€"
        "Twk_TTL" = "РЎРєСЂС‹С‚СЊ СЂРµР°Р»СЊРЅС‹Р№ TTL"
        "Twk_Notif" = "РћС‚РєР»СЋС‡РёС‚СЊ Р»РёС€РЅРёРµ СѓРІРµРґРѕРјР»РµРЅРёСЏ Рё СЂРµРєРѕРјРµРЅРґР°С†РёРё"
        "Twk_DNS" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ DNS Cloudflare РЅР° Wi-Fi Р°РґР°РїС‚РµСЂС‹"
        "Twk_Hosts" = "Р‘Р»РѕРєРёСЂРѕРІРєР° С‚РµР»РµРјРµС‚СЂРёРё (hosts)"
        
        "Sec_Drivers" = "Р”СЂР°Р№РІРµСЂС‹"
        "Twk_InstallDrv" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ РґСЂР°Р№РІРµСЂС‹ (РџР°РїРєР° Drivers РЅР° Р Р°Р±РѕС‡РµРј СЃС‚РѕР»Рµ)"
        
        "Sec_Other" = "Р”СЂСѓРіРёРµ РєРѕРјРїРѕРЅРµРЅС‚С‹"
        "Twk_VC" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Visual C++"
        "Twk_DX" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ DirectX 9-11"
        
        "Sec_Visual" = "Р’РёР·СѓР°Р»СЊРЅС‹Рµ С‚РІРёРєРё"
        "Twk_Home" = "РЈРґР°Р»РёС‚СЊ РїСѓРЅРєС‚ Р“Р»Р°РІРЅР°СЏ РІ РџСЂРѕРІРѕРґРЅРёРєРµ"
        "Twk_Gallery" = "РЈРґР°Р»РёС‚СЊ РїСѓРЅРєС‚ Р“Р°Р»РµСЂРµСЏ РІ РџСЂРѕРІРѕРґРЅРёРєРµ"
        "Twk_Network" = "РЈРґР°Р»РёС‚СЊ РїСѓРЅРєС‚ РЎРµС‚СЊ РІ РџСЂРѕРІРѕРґРЅРёРєРµ"
        "Twk_DarkTheme" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ С‚РµРјРЅСѓСЋ С‚РµРјСѓ СЃРёСЃС‚РµРјС‹"
        "Twk_Wall" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ РєР°СЃС‚РѕРјРЅС‹Рµ РѕР±РѕРё"
        "Twk_BlueIcon" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ СЃРёРЅРёРµ РїР°РїРєРё"
        "Twk_Icaros" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ РґРѕРїРѕР»РЅРёС‚РµР»СЊРЅС‹Рµ СЌСЃРєРёР·С‹ РјРµРґРёР°С„Р°Р№Р»РѕРІ (Icaros)"
        "Twk_TraySec" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ СЃРµРєСѓРЅРґС‹ РІ С‚СЂРµРµ"
        "Twk_TrayDate" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ РґР°С‚Сѓ РІ С‚СЂРµРµ"
        "Twk_EndTask" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ РїСѓРЅРєС‚ Р—Р°РІРµСЂС€РёС‚СЊ Р·Р°РґР°С‡Сѓ РЅР° РџР°РЅРµР»Рё Р·Р°РґР°С‡"
        "Twk_RmTaskIcon" = "РЈРґР°Р»РёС‚СЊ Р»РёС€РЅРёРµ Р·РЅР°С‡РєРё РЅР° РџР°РЅРµР»Рё Р·Р°РґР°С‡"
        "Twk_HideRec" = "РЎРєСЂС‹С‚СЊ СЂР°Р·РґРµР» Р РµРєРѕРјРµРЅРґСѓРµРј РІ РјРµРЅСЋ РџСѓСЃРє"
        "Twk_StartSet" = "РЈСЃС‚Р°РЅРѕРІРёС‚СЊ Р·РЅР°С‡РѕРє РќР°СЃС‚СЂРѕР№РєРё РІ РјРµРЅСЋ РџСѓСЃРє"
        "Twk_WallQual" = "РЈРґР°Р»РёС‚СЊ СЃР¶Р°С‚РёРµ РѕР±РѕРµРІ Р Р°Р±РѕС‡РµРіРѕ СЃС‚РѕР»Р°"
        "Twk_RmLock" = "РЈРґР°Р»РёС‚СЊ СЌРєСЂР°РЅ Р±Р»РѕРєРёСЂРѕРІРєРё"
        "Twk_NoIconShad" = "РЈРґР°Р»РёС‚СЊ С‚РµРЅРё РЅР° Р·РЅР°С‡РєР°С… Р Р°Р±РѕС‡РµРіРѕ СЃС‚РѕР»Р°"
        "Twk_ExplPC" = "РћС‚РєСЂС‹РІР°С‚СЊ РџСЂРѕРІРѕРґРЅРёРє РІ Р­С‚РѕС‚ РєРѕРјРїСЊСЋС‚РµСЂ"
        "Twk_ShowExt" = "РџРѕРєР°Р·С‹РІР°С‚СЊ СЂР°СЃС€РёСЂРµРЅРёСЏ С„Р°Р№Р»РѕРІ"
        "Twk_ClassMenu" = "РљР»Р°СЃСЃРёС‡РµСЃРєРѕРµ РєРѕРЅС‚РµРєСЃС‚РЅРѕРµ РјРµРЅСЋ (Win10)"
        "Twk_LeftTask" = "РџР°РЅРµР»СЊ Р·Р°РґР°С‡ РїРѕ Р»РµРІРѕРјСѓ РєСЂР°СЋ"
        
        "Sec_Compress" = "РЎР¶Р°С‚РёРµ СЃРёСЃС‚РµРјС‹"
        "Twk_CompOS" = "РњР°РєСЃРёРјР°Р»СЊРЅРѕРµ СЃР¶Р°С‚РёРµ СЃРёСЃС‚РµРјРЅС‹С… С„Р°Р№Р»РѕРІ"
        "Twk_CompDrive" = "РњР°РєСЃРёРјР°Р»СЊРЅРѕРµ СЃР¶Р°С‚РёРµ СЃРёСЃС‚РµРјРЅС‹С… Рё РїСЂРѕРіСЂР°РјРјРЅС‹С… С„Р°Р№Р»РѕРІ"
    }
    "EN" = @{
        "RebootTitle" = "Optimization Complete!`n`nReboot PC now?"
        "Yes" = "YES"
        "No" = "NO"
        "Optimize" = "APPLY TWEAKS"
        "LangToggle" = "RU"
        
        "Sec_Cleanup" = "Cleanup"
        "Twk_Updates" = "Remove Windows Update files"
        "Twk_StoreCache" = "Remove Windows Store cache"
        "Twk_ExplorerCache" = "Remove Explorer cache"
        "Twk_WinSxS" = "Clean WinSxS storage"
        "Twk_JunkFolders" = "Remove junk folders on C: drive"
        "Twk_OldDrivers" = "Remove old drivers"
        "Twk_ShellBags" = "Remove ShellBags"
        
        "Sec_Preinstalled" = "Preinstalled Apps"
        "Twk_UWP" = "Remove all UWP apps"
        "Twk_OneDrive" = "Remove OneDrive"
        "Twk_RemoteAssist" = "Remove Remote Assistance"
        "Twk_StartMenu" = "Clean up Start Menu bloatware folders"
        
        "Sec_Edge" = "Edge Browser & WebView2"
        "Twk_Edge" = "Remove Microsoft Edge"
        "Twk_WebView" = "Remove Edge WebView2"
        
        "Sec_Defender" = "Windows Defender"
        "Twk_Defender" = "Remove Windows Defender (DefenderKiller)"
        
        "Sec_Components" = "Windows Components"
        "Twk_Components" = "Remove all optional components"
        
        "Sec_Tasks" = "Task Scheduler"
        "Twk_Tasks" = "Disable telemetry and diagnostic tasks"
        
        "Sec_OptParams" = "System Optimization"
        "Twk_Hibernate" = "Disable Hibernation"
        "Twk_ResStorage" = "Disable Reserved Storage"
        "Twk_RestorePts" = "Disable System Restore Points"
        "Twk_DelayedSvc" = "Delayed start for automatic services"
        "Twk_SysLog" = "Minimize system logging"
        "Twk_BoostIcon" = "Increase icon cache"
        "Twk_SvcSplit" = "Increase SVC split threshold"
        "Twk_FastFolder" = "Speed up folder opening"
        "Twk_DisableVBS" = "Disable VBS and HVCI"
        "Twk_GameDVR" = "Disable GameDVR"
        "Twk_UltPerf" = "Enable Ultimate Performance power plan"
        "Twk_Resume" = "Disable Resume feature"
        
        "Sec_WinUpdate" = "Windows Update"
        "Twk_WUDrivers" = "Disable driver installation from WU"
        "Twk_DefUpdates" = "Disable Defender malicious software updates"
        "Twk_PauseUpd" = "Pause updates until 07.07.2077"
        "Twk_NoAutoUpd" = "Disable automatic updates"
        
        "Sec_Useful" = "Useful Tweaks"
        "Twk_UAC" = "Disable UAC"
        "Twk_Admin" = "Enable Built-in Administrator account"
        "Twk_Region" = "Unlock regional restrictions"
        "Twk_KillFreeze" = "Force kill frozen applications"
        "Twk_Remote" = "Disable Remote Assistance"
        "Twk_Sticky" = "Disable Sticky Keys"
        "Twk_TTL" = "Hide real TTL"
        "Twk_Notif" = "Disable unwanted notifications and tips"
        "Twk_DNS" = "Set Cloudflare DNS on Wi-Fi adapters"
        "Twk_Hosts" = "Block telemetry (hosts file)"
        
        "Sec_Drivers" = "Drivers"
        "Twk_InstallDrv" = "Install drivers (Drivers folder on Desktop)"
        
        "Sec_Other" = "Other Components"
        "Twk_VC" = "Install Visual C++ Redistributable"
        "Twk_DX" = "Install DirectX 9-11"
        
        "Sec_Visual" = "Visual Tweaks"
        "Twk_Home" = "Remove Home from Explorer"
        "Twk_Gallery" = "Remove Gallery from Explorer"
        "Twk_Network" = "Remove Network from Explorer"
        "Twk_DarkTheme" = "Enable dark system theme"
        "Twk_Wall" = "Set custom wallpaper"
        "Twk_BlueIcon" = "Set blue folder icons"
        "Twk_Icaros" = "Install extended media thumbnails (Icaros)"
        "Twk_TraySec" = "Show seconds in system tray"
        "Twk_TrayDate" = "Show date in system tray"
        "Twk_EndTask" = "Enable End Task on Taskbar"
        "Twk_RmTaskIcon" = "Remove useless Taskbar icons"
        "Twk_HideRec" = "Hide Recommended section in Start Menu"
        "Twk_StartSet" = "Add Settings icon to Start Menu"
        "Twk_WallQual" = "Disable desktop wallpaper compression"
        "Twk_RmLock" = "Remove Lock Screen"
        "Twk_NoIconShad" = "Remove drop shadows on desktop icons"
        "Twk_ExplPC" = "Open Explorer to This PC"
        "Twk_ShowExt" = "Show file extensions"
        "Twk_ClassMenu" = "Classic Context Menu (Win10 style)"
        "Twk_LeftTask" = "Align Taskbar to left"
        
        "Sec_Compress" = "System Compression"
        "Twk_CompOS" = "Maximum compression of system files (CompactOS)"
        "Twk_CompDrive" = "Maximum compression of system and program files"
    }
}

function L([string]$key) {
    return $loc[$global:Lang][$key]
}

$global:locElements = @()

function Register-Loc($element, $key) {
    $global:locElements += @{ Element = $element; Key = $key }
    if ($element -is [System.Windows.Controls.Label] -or $element -is [System.Windows.Controls.Button] -or $element -is [System.Windows.Controls.CheckBox]) {
        $element.Content = L $key
    }
    if ($element -is [System.Windows.Controls.TextBlock]) {
        $element.Text = L $key
    }
}

function Update-LanguageUI {
    foreach ($item in $global:locElements) {
        if ($item.Element -is [System.Windows.Controls.Label] -or $item.Element -is [System.Windows.Controls.Button] -or $item.Element -is [System.Windows.Controls.CheckBox]) {
            $item.Element.Content = L $item.Key
        }
        if ($item.Element -is [System.Windows.Controls.TextBlock]) {
            $item.Element.Text = L $item.Key
        }
    }
}
# ================= Р¤РЈРќРљР¦РР =================
function Show-RebootPrompt {
    $doneWin = [System.Windows.Window]::new()
    $doneWin.Width = 250; $doneWin.Height = 130; $doneWin.AllowsTransparency = $true; $doneWin.WindowStyle = "None"
    $doneWin.WindowStartupLocation = "CenterScreen"; $doneWin.Topmost = $true; $doneWin.Background = [System.Windows.Media.Brushes]::Transparent
    
    $doneBorder = [System.Windows.Controls.Border]::new()
    $doneBorder.Background = $darkGrayBrush; $doneBorder.CornerRadius = 12; $doneBorder.BorderBrush = $accentBrush; $doneBorder.BorderThickness = 1
    
    $doneStack = [System.Windows.Controls.StackPanel]::new()
    $doneStack.VerticalAlignment = "Center"
    $doneText = [System.Windows.Controls.TextBlock]::new()
    Register-Loc $doneText "RebootTitle"
    $doneText.Foreground = $whiteBrush
    $doneText.TextAlignment = "Center"; $doneText.Margin = "0,-5,0,10"; $doneText.FontFamily = "Bahnschrift"
    
    $btnP = [System.Windows.Controls.StackPanel]::new(); $btnP.Orientation = "Horizontal"; $btnP.HorizontalAlignment = "Center"
    $bR = [System.Windows.Controls.Button]::new(); 
    Register-Loc $bR "Yes"
    $bR.Style = $buttonStyle; $bR.Width = 70; $bR.Height = 28; $bR.FontFamily = "Bahnschrift"
    
    Set-FadeIn $doneWin
    
    $bR.Add_Click({ 
        Close-WindowAnimated $doneWin
        Start-Process "shutdown.exe" -ArgumentList "/r /t 1 /f" -WindowStyle Hidden
    })
    $bC = [System.Windows.Controls.Button]::new(); 
    Register-Loc $bC "No"
    $bC.Style = $buttonStyle; $bC.Width = 70; $bC.Height = 28; $bC.FontFamily = "Bahnschrift"
    $bC.Add_Click({ 
        Close-WindowAnimated $doneWin
    })
    $bR.Margin = [System.Windows.Thickness]::new(0, 10, 5, 0) 
    $bC.Margin = [System.Windows.Thickness]::new(5, 10, 0, 0)
    $btnP.Children.Add($bR); $btnP.Children.Add($bC)
    $doneStack.Children.Add($doneText); $doneStack.Children.Add($btnP)
    $doneBorder.Child = $doneStack; $doneWin.Content = $doneBorder
    $doneWin.ShowDialog() | Out-Null
}

function Update-OptimizeButtonState {
    $anyChecked = $false
    foreach ($cb in $allCBs) {
        if ($cb.IsChecked) {
            $anyChecked = $true
            break
        }
    }
    $btnOpt.IsEnabled = $anyChecked
}

function Get-CustomImage {
    param([string]$fileName)
    $imgPath = Join-Path $workDir $fileName
    if (Test-Path $imgPath) {
        try {
            $bitmap = [System.Windows.Media.Imaging.BitmapImage]::new()
            $bitmap.BeginInit()
            $bitmap.UriSource = [Uri]$imgPath
            $bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
            $bitmap.EndInit()
            
            $img = [System.Windows.Controls.Image]::new()
            $img.Source = $bitmap
            $img.Width = 18
            $img.Height = 18
            return $img
        } catch { return $null }
    }
    return $null
}

function Create-IconButton {
    param($imgName, $url, $tip)
    $btn = [System.Windows.Controls.Border]::new()
    $btn.Width = 24; $btn.Height = 24
    $btn.Background = [System.Windows.Media.Brushes]::Transparent
    $btn.Cursor = [System.Windows.Input.Cursors]::Hand
    $btn.ToolTip = $tip
    
    $icon = Get-CustomImage $imgName
    if ($icon) {
        $icon.Width = 16; $icon.Height = 16
        $icon.Opacity = 0.7
        $btn.Child = $icon
    }
    
    $btn.Add_MouseDown({ Start-Process $url }.GetNewClosure())
    $btn.Add_MouseEnter({ if ($this.Child) { $this.Child.Opacity = 1.0 } })
    $btn.Add_MouseLeave({ if ($this.Child) { $this.Child.Opacity = 0.7 } })
    
    return $btn
}

function Set-FadeIn($win) {
    $win.Opacity = 0 
    $win.Add_Loaded({
        $fadeIn = New-Object System.Windows.Media.Animation.DoubleAnimation
        $fadeIn.From = 0
        $fadeIn.To = 1
        $fadeIn.Duration = [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(300))
        $fadeIn.EasingFunction = New-Object System.Windows.Media.Animation.QuadraticEase -Property @{ EasingMode = "EaseOut" }
        
        $this.BeginAnimation([System.Windows.Window]::OpacityProperty, $fadeIn)
    })
}

function Close-WindowAnimated($win) {
    if ($null -eq $win -or $win.Tag -eq "Closing") { return }
    $win.Tag = "Closing"
    
    $fadeOut = New-Object System.Windows.Media.Animation.DoubleAnimation
    $fadeOut.From = $win.Opacity
    $fadeOut.To = 0
    $fadeOut.Duration = [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(200))
    $fadeOut.Add_Completed({ 
        $win.Close() 
    }.GetNewClosure())
    
    $win.BeginAnimation([System.Windows.Window]::OpacityProperty, $fadeOut)
}

# ================= Р¦Р’Р•РўРђ Р РЎРўРР›Р =================
$darkGrayBrush = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(20,22,25))
$cardBrush     = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(30,34,40))
$accentBrush   = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(94,129,172))
$whiteBrush    = [System.Windows.Media.Brushes]::White
$borderBrush   = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(60,60,60))
$cardBorderBrush = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Colors]::Gray)
$cardBorderBrush.Opacity = 0.2

$buttonStyle = [System.Windows.Markup.XamlReader]::Parse(@"
<Style TargetType='Button' xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'>
  <Setter Property='Margin' Value='20,10,20,20'/><Setter Property='Height' Value='45'/><Setter Property='FontSize' Value='12'/><Setter Property='FontWeight' Value='Bold'/>
  <Setter Property='Background' Value='#5E81AC'/><Setter Property='Foreground' Value='White'/><Setter Property='BorderThickness' Value='0'/>
  <Setter Property='RenderTransformOrigin' Value='0.5,0.5'/>
  <Setter Property='Template'>
    <Setter.Value>
      <ControlTemplate TargetType='Button'>
        <Border Name='border' Background='{TemplateBinding Background}' CornerRadius='8' RenderTransformOrigin='0.5,0.5'>
          <Border.RenderTransform><ScaleTransform ScaleX='1' ScaleY='1'/></Border.RenderTransform>
          <ContentPresenter HorizontalAlignment='Center' VerticalAlignment='Center'/>
        </Border>
        <ControlTemplate.Triggers>
		<Trigger Property='IsEnabled' Value='False'>
			<Setter TargetName='border' Property='Background' Value='#2A2E33'/>
			<Setter Property='Foreground' Value='#555555'/>
			</Trigger>
          <Trigger Property='IsMouseOver' Value='True'><Setter TargetName='border' Property='Background' Value='#4C566A'/></Trigger>
          <Trigger Property='IsPressed' Value='True'><Setter TargetName='border' Property='RenderTransform'><Setter.Value><ScaleTransform ScaleX='0.98' ScaleY='0.98'/></Setter.Value></Setter></Trigger>
        </ControlTemplate.Triggers>
      </ControlTemplate>
    </Setter.Value>
  </Setter>
</Style>
"@)

$checkboxTemplate = [System.Windows.Markup.XamlReader]::Parse(@"
<ControlTemplate xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation' TargetType='CheckBox'>
  <Border Name='Bg' Background='Transparent' CornerRadius='4' Padding='4'>
    <BulletDecorator Background='Transparent'>
      <BulletDecorator.Bullet>
        <Grid Width='18' Height='18'>
          <Border Name='Border' CornerRadius='4' Background='Transparent' BorderBrush='White' BorderThickness='1'/>
          <Path Name='CheckMark' Visibility='Hidden' Stroke='#5E81AC' StrokeThickness='2' Data='M3,9 L7,13 L15,5'/>
        </Grid>
      </BulletDecorator.Bullet>
      <ContentPresenter VerticalAlignment='Center' Margin='10,0,0,0'/>
    </BulletDecorator>
  </Border>
  <ControlTemplate.Triggers>
    <Trigger Property='IsChecked' Value='True'><Setter TargetName='CheckMark' Property='Visibility' Value='Visible'/><Setter TargetName='Border' Property='BorderBrush' Value='#5E81AC'/></Trigger>
    <Trigger Property='IsMouseOver' Value='True'><Setter TargetName='Bg' Property='Background' Value='#3D4450'/><Setter TargetName='Border' Property='BorderBrush' Value='#5E81AC'/></Trigger>
  </ControlTemplate.Triggers>
</ControlTemplate>
"@)

# ================= Р’РЎР• Р РђР—Р”Р•Р›Р« Р РўР’РРљР =================
$tweaks = [ordered]@{
    "Sec_Cleanup" = @(
        @("Twk_Updates", "/RemoveUpdateFiles"),
        @("Twk_StoreCache", "/RemoveStoreCache"),
        @("Twk_ExplorerCache", "/RemoveExplorerCache"),
        @("Twk_WinSxS", "/CleanWinSxS"),
        @("Twk_JunkFolders", "/RemoveJunkFolders"),
        @("Twk_OldDrivers", "/RemoveOldDrivers"),
        @("Twk_ShellBags", "/RemoveShellBags")
    )
    "Sec_Preinstalled" = @(
        @("Twk_UWP", "/RemoveAppx"),
        @("Twk_OneDrive", "/RemoveOneDrive"),
        @("Twk_RemoteAssist", "/RemoveRemoteAssistant"),
        @("Twk_StartMenu", "/CleanStartMenu")
    )
    "Sec_Edge" = @(
        @("Twk_Edge", "/RemoveEdge"),
        @("Twk_WebView", "/RemoveEdgeWebView")
    )
    "Sec_Defender" = @(
        ,@("Twk_Defender", "/RemoveDefender")
    )
	"Sec_Components" = @(
        ,@("Twk_Components", "/RemoveComponents")
    )
    "Sec_Tasks" = @(
        ,@("Twk_Tasks", "/DisableTasks")
    )
    "Sec_OptParams" = @(
        @("Twk_Hibernate", "/DisableHibernate"),
		@("Twk_ResStorage", "/DisableReservedStorage"),
        @("Twk_RestorePts", "/DisableRestorePoints"),
		@("Twk_DelayedSvc", "/DelayedServices"),
		@("Twk_SysLog", "/SystemLog"),
		@("Twk_BoostIcon", "/BoostIconCache"),
		@("Twk_SvcSplit", "/SvcSplit"),
		@("Twk_FastFolder", "/FastFolders"),
		@("Twk_DisableVBS", "/DisableVBS"),
        @("Twk_GameDVR", "/DisableGameDVR"),
		@("Twk_UltPerf", "/UltimatePerformance"),
		@("Twk_Resume", "/DisableResume")
    )
    "Sec_WinUpdate" = @(
        @("Twk_WUDrivers", "/DisableWUDrivers"),
		@("Twk_DefUpdates", "/DisableDefenderUpdates"),
		@("Twk_PauseUpd", "/PauseUpdates"),
		@("Twk_NoAutoUpd", "/DisableAutoUpdates")
    )
    "Sec_Useful" = @(
        @("Twk_UAC", "/DisableUAC"),
		@("Twk_Admin", "/EnableAdmin"),
		@("Twk_Region", "/UnlockRegion"),
		@("Twk_KillFreeze", "/KillFreezeApps"),
		@("Twk_Remote", "/DisableRemote"),
		@("Twk_Sticky", "/DisableStickyKeys"),
		@("Twk_TTL", "/TTL"),
		@("Twk_Notif", "/DisableNotificationsAds"),
		@("Twk_DNS", "/DNS"),
		@("Twk_Hosts", "/BlockTelemetry")
    )
    "Sec_Drivers" = @(
        ,@("Twk_InstallDrv", "/InstallDrivers")
	)
	"Sec_Other" = @(
        @("Twk_VC", "/InstallVC"),
        @("Twk_DX", "/InstallDX")
    )
    "Sec_Visual" = @(
        @("Twk_Home", "/RemoveHome"),
        @("Twk_Gallery", "/RemoveGallery"),
        @("Twk_Network", "/RemoveNetwork"),
		@("Twk_DarkTheme", "/DarkTheme"),
		@("Twk_Wall", "/SetWallpaper"),
		@("Twk_BlueIcon", "/BlueIcons"),
		@("Twk_Icaros", "/Icaros"),
		@("Twk_TraySec", "/TraySeconds"),
		@("Twk_TrayDate", "/TrayDate"),
		@("Twk_EndTask", "/TaskbarEndTask"),
		@("Twk_RmTaskIcon", "/RemoveTaskbarIcons"),
		@("Twk_HideRec", "/HideRecommended"),
		@("Twk_StartSet", "/StartSettingsIcon"),
		@("Twk_WallQual", "/WallpaperQuality"),
		@("Twk_RmLock", "/RemoveLockScreen"),
		@("Twk_NoIconShad", "/NoIconShadow"),
		@("Twk_ExplPC", "/ExplorerThisPC"),
		@("Twk_ShowExt", "/ShowExtensions"),
		@("Twk_ClassMenu", "/ClassicContextMenu"),
		@("Twk_LeftTask", "/LeftTaskbar")
    )
    "Sec_Compress" = @(
        @("Twk_CompOS", "/CompressOS"),
		@("Twk_CompDrive", "/CompressDrive")
    )
}

# ================= РљРћРќРЎРўР РЈРљРўРћР  UI =================
$window = [System.Windows.Window]::new()
$window.Title = "SysTweakX"
$window.Width = 450
$window.Height = 650
$window.Background = [System.Windows.Media.Brushes]::Transparent
$window.AllowsTransparency = $true
$window.WindowStyle = "None"
$window.WindowStartupLocation = "CenterScreen"
$window.ResizeMode = "NoResize"

$mainBorder = [System.Windows.Controls.Border]::new()
$mainBorder.Background = $darkGrayBrush
$mainBorder.CornerRadius = [System.Windows.CornerRadius]::new(15)
$mainBorder.BorderBrush = $accentBrush
$mainBorder.BorderThickness = [System.Windows.Thickness]::new(1)

$root = [System.Windows.Controls.Grid]::new()
$root.RowDefinitions.Add([System.Windows.Controls.RowDefinition]::new())
$root.RowDefinitions[0].Height = [System.Windows.GridLength]::Auto
$root.RowDefinitions.Add([System.Windows.Controls.RowDefinition]::new())
$root.RowDefinitions.Add([System.Windows.Controls.RowDefinition]::new())
$root.RowDefinitions[2].Height = [System.Windows.GridLength]::Auto

$headerContainer = [System.Windows.Controls.StackPanel]::new()
$headerContainer.Margin = [System.Windows.Thickness]::new(0,15,0,10)
$headerContainer.Background = [System.Windows.Media.Brushes]::Transparent
$headerContainer.Add_MouseLeftButtonDown({ $window.DragMove() })
[System.Windows.Controls.Grid]::SetRow($headerContainer, 0)
$root.Children.Add($headerContainer) | Out-Null

$navCard = [System.Windows.Controls.Border]::new()
$navCard.Background = $cardBrush
$navCard.BorderBrush = $cardBorderBrush
$navCard.BorderThickness = [System.Windows.Thickness]::new(1)
$navCard.CornerRadius = [System.Windows.CornerRadius]::new(8)
$navCard.HorizontalAlignment = "Right"
$navCard.VerticalAlignment = "Top"
$navCard.Margin = [System.Windows.Thickness]::new(0,20,20,0)
$navCard.Padding = [System.Windows.Thickness]::new(3,0,4,0)

$navStack = [System.Windows.Controls.StackPanel]::new()
$navStack.Orientation = "Horizontal"
$navCard.Child = $navStack

# Language Toggle
$langToggle = [System.Windows.Controls.Label]::new()
Register-Loc $langToggle "LangToggle"
$langToggle.FontSize = 11; $langToggle.FontWeight = [System.Windows.FontWeights]::Bold
$langToggle.Foreground = [System.Windows.Media.Brushes]::LightGray; $langToggle.FontFamily = "Bahnschrift"
$langToggle.Cursor = [System.Windows.Input.Cursors]::Hand
$langToggle.VerticalAlignment = "Center"; $langToggle.Margin = [System.Windows.Thickness]::new(2,-2,2,0)
$langToggle.Add_MouseEnter({ $this.Foreground = $accentBrush })
$langToggle.Add_MouseLeave({ $this.Foreground = [System.Windows.Media.Brushes]::LightGray })
$langToggle.Add_MouseDown({
    if ($global:Lang -eq "RU") { $global:Lang = "EN" } else { $global:Lang = "RU" }
    Update-LanguageUI
})
$navStack.Children.Add($langToggle) | Out-Null

$sep1 = [System.Windows.Controls.Border]::new()
$sep1.Width = 1; $sep1.Height = 14; $sep1.Background = [System.Windows.Media.Brushes]::Gray
$sep1.Opacity = 0.3; $sep1.Margin = [System.Windows.Thickness]::new(4,0,4,0)
$sep1.VerticalAlignment = "Center"
$navStack.Children.Add($sep1) | Out-Null

$navStack.Children.Add((Create-IconButton "GitHub.ico" "https://github.com/dimazzq92" "GitHub")) | Out-Null

$sep2 = [System.Windows.Controls.Border]::new()
$sep2.Width = 1; $sep2.Height = 14; $sep2.Background = [System.Windows.Media.Brushes]::Gray
$sep2.Opacity = 0.3; $sep2.Margin = [System.Windows.Thickness]::new(4,0,4,0)
$sep2.VerticalAlignment = "Center"
$navStack.Children.Add($sep2) | Out-Null

$closeWrapper = [System.Windows.Controls.Border]::new()
$closeWrapper.Width = 24; $closeWrapper.Height = 24
$closeWrapper.Background = [System.Windows.Media.Brushes]::Transparent
$closeWrapper.Cursor = [System.Windows.Input.Cursors]::Hand

$closeTxt = [System.Windows.Controls.TextBlock]::new()
$closeTxt.Text = "r"; $closeTxt.FontFamily = "Marlett"; $closeTxt.FontSize = 16; $closeTxt.Margin = "0,2,0,0"
$closeTxt.Foreground = [System.Windows.Media.Brushes]::Gray
$closeTxt.HorizontalAlignment = "Center"; $closeTxt.VerticalAlignment = "Center"
$closeWrapper.Child = $closeTxt
$closeWrapper.Add_MouseEnter({ $closeTxt.Foreground = [System.Windows.Media.Brushes]::IndianRed })
$closeWrapper.Add_MouseLeave({ $closeTxt.Foreground = [System.Windows.Media.Brushes]::Gray })
$closeWrapper.Add_MouseDown({ Close-WindowAnimated $window })

$navStack.Children.Add($closeWrapper) | Out-Null
[System.Windows.Controls.Grid]::SetRow($navCard, 0)
$root.Children.Add($navCard) | Out-Null

$headerTxt = [System.Windows.Controls.Label]::new()
$headerTxt.Content = "SysTweakX"; $headerTxt.FontSize = 26; $headerTxt.FontWeight = [System.Windows.FontWeights]::Bold
$headerTxt.Foreground = $accentBrush; $headerTxt.Margin = [System.Windows.Thickness]::new(25,0,0,0); $headerTxt.FontFamily = "Bahnschrift"
$headerTxt.Add_MouseDoubleClick({
    $items = $this.Tag
    if ($null -ne $items) {
        $allUnchecked = ($items | Where-Object { -not $_.IsChecked }).Count -eq $items.Count
        foreach ($item in $items) {
            $item.IsChecked = $allUnchecked
        }
    }
})

$headerContainer.Children.Add($headerTxt) | Out-Null
$scroll = [System.Windows.Controls.ScrollViewer]::new()
$scroll.VerticalScrollBarVisibility = "Hidden"; $scroll.Margin = [System.Windows.Thickness]::new(20,-10,20,-15); $scroll.BorderThickness = [System.Windows.Thickness]::new(0)

$mask = [System.Windows.Media.LinearGradientBrush]::new()
$mask.StartPoint = "0,0"; $mask.EndPoint = "0,1"

$stopTop = [System.Windows.Media.GradientStop]::new([System.Windows.Media.Colors]::Black, 0.0)
$stopTopFade = [System.Windows.Media.GradientStop]::new([System.Windows.Media.Colors]::Black, 0.05)
$stopBottomFade = [System.Windows.Media.GradientStop]::new([System.Windows.Media.Colors]::Black, 0.90)
$stopBottom = [System.Windows.Media.GradientStop]::new([System.Windows.Media.Colors]::Black, 1.0)

$mask.GradientStops.Add($stopTop)
$mask.GradientStops.Add($stopTopFade)
$mask.GradientStops.Add($stopBottomFade)
$mask.GradientStops.Add($stopBottom)
$scroll.OpacityMask = $mask
$scroll.Add_ScrollChanged({
    if ($scroll.VerticalOffset -gt 0) { $stopTop.Color = [System.Windows.Media.Colors]::Transparent }
    else { $stopTop.Color = [System.Windows.Media.Colors]::Black }
    
    if ($scroll.VerticalOffset -lt $scroll.ScrollableHeight) { $stopBottom.Color = [System.Windows.Media.Colors]::Transparent }
    else { $stopBottom.Color = [System.Windows.Media.Colors]::Black }
})

$script:scrollTimer = $null
$script:scrollVelocity = 0

$scroll.Add_PreviewMouseWheel({
    param($s, $e)
    $e.Handled = $true
    $script:scrollVelocity += -$e.Delta / 120 * 15
    if (-not $script:scrollTimer) {
        $script:scrollTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:scrollTimer.Interval = [TimeSpan]::FromMilliseconds(1)
        $script:scrollTimer.Add_Tick({
            if ([math]::Abs($script:scrollVelocity) -lt 0.1) {
                $script:scrollTimer.Stop()
                return
            }
            $newOffset = $scroll.VerticalOffset + $script:scrollVelocity
            if ($newOffset -lt 0) { 
                $newOffset = 0
                $script:scrollVelocity = 0
            }
            if ($newOffset -gt $scroll.ScrollableHeight) {
                $newOffset = $scroll.ScrollableHeight
                $script:scrollVelocity = 0
            }
            $scroll.ScrollToVerticalOffset($newOffset)
            $script:scrollVelocity *= 0.8
        })
    }
    $script:scrollTimer.Start()
})

$stack = [System.Windows.Controls.StackPanel]::new()
$scroll.Content = [System.Windows.Controls.Border]::new()
$scroll.Content.Padding = [System.Windows.Thickness]::new(0,20,0,10)
$scroll.Content.Child = $stack
[System.Windows.Controls.Grid]::SetRow($scroll, 1)
$root.Children.Add($scroll) | Out-Null

$allCBs = [System.Collections.Generic.List[System.Windows.Controls.CheckBox]]::new()

foreach ($secKey in $tweaks.Keys) {
    $card = [System.Windows.Controls.Border]::new()
    $card.Background = $cardBrush; $card.CornerRadius = [System.Windows.CornerRadius]::new(10)
    $card.Margin = [System.Windows.Thickness]::new(0,0,0,20); $card.Padding = [System.Windows.Thickness]::new(15)
	
	$card.BorderThickness = [System.Windows.Thickness]::new(1)
    $card.BorderBrush = $cardBorderBrush
    
    $cardStack = [System.Windows.Controls.StackPanel]::new()
    $sectionCBs = [System.Collections.Generic.List[System.Windows.Controls.CheckBox]]::new()

	$secHeader = [System.Windows.Controls.Label]::new()
    Register-Loc $secHeader $secKey
    $secHeader.FontSize = 12; $secHeader.FontWeight = [System.Windows.FontWeights]::Bold 
    $secHeader.Foreground = [System.Windows.Media.Brushes]::LightGray; $secHeader.Margin = [System.Windows.Thickness]::new(-5,-5,0,12)
    $secHeader.Cursor = [System.Windows.Input.Cursors]::Hand; $secHeader.Tag = $sectionCBs; $secHeader.FontFamily = "Bahnschrift"
    
    $secHeader.Add_MouseEnter({ $this.Foreground = $accentBrush })
    $secHeader.Add_MouseLeave({ $this.Foreground = [System.Windows.Media.Brushes]::LightGray })
	$secHeader.Add_MouseDown({
    $items = $this.Tag
    $allUnchecked = ($items | Where-Object { -not $_.IsChecked }).Count -eq $items.Count
    foreach ($item in $items) {
        $item.IsChecked = $allUnchecked
    }
    Update-OptimizeButtonState
	})
    
    $cardStack.Children.Add($secHeader) | Out-Null

    $currentList = $tweaks[$secKey]
    if ($currentList.Count -eq 2 -and $currentList[0] -is [string]) { $currentList = ,$currentList }

	foreach ($tweak in $currentList) {
        $cb = [System.Windows.Controls.CheckBox]::new()
        Register-Loc $cb $tweak[0]
        $cb.Tag = $tweak[1]; $cb.Template = $checkboxTemplate
        $cb.Foreground = [System.Windows.Media.Brushes]::Gray; $cb.Margin = [System.Windows.Thickness]::new(0,0,5,5)
        $cb.FontSize = 11; $cb.Cursor = [System.Windows.Input.Cursors]::Hand; $cb.FontFamily = "Bahnschrift"

		$cb.Add_Checked({ 
			$this.Foreground = [System.Windows.Media.Brushes]::White 
			Update-OptimizeButtonState
		})
		$cb.Add_Unchecked({ 
			$this.Foreground = [System.Windows.Media.Brushes]::Gray 
			Update-OptimizeButtonState
		})

        $cardStack.Children.Add($cb) | Out-Null
        $allCBs.Add($cb)
        $sectionCBs.Add($cb)
    }
    $card.Child = $cardStack
    $stack.Children.Add($card) | Out-Null
}

$headerTxt.Tag = $allCBs

# ================= Р›РћР“РРљРђ РЎР–РђРўРРЇ =================
$cbCompressOS = $allCBs | Where-Object { $_.Tag -eq "/CompressOS" }
$cbCompressDrive = $allCBs | Where-Object { $_.Tag -eq "/CompressDrive" }

function Set-CompressCheckbox {
    param($target, $value)
    $target.Remove_Checked($null)
    $target.IsChecked = $value
}

$global:isUpdating = $false

$cbCompressOS.Add_Checked({
    if ($global:isUpdating) { return }
    $global:isUpdating = $true
    $cbCompressDrive.IsChecked = $false
    $global:isUpdating = $false
})

$cbCompressDrive.Add_Checked({
    if ($global:isUpdating) { return }
    $global:isUpdating = $true
    $cbCompressOS.IsChecked = $false
    $global:isUpdating = $false
})

$btnOpt = [System.Windows.Controls.Button]::new()
Register-Loc $btnOpt "Optimize"
$btnOpt.Style = $buttonStyle
$btnOpt.Cursor = [System.Windows.Input.Cursors]::Hand
$btnOpt.FontFamily = "Bahnschrift"
$btnOpt.FontSize = 18
$btnOpt.IsEnabled = $false
[System.Windows.Controls.Grid]::SetRow($btnOpt, 2)
$root.Children.Add($btnOpt) | Out-Null

$btnOpt.Add_Click({
    $selected = $allCBs | Where-Object { $_.IsChecked }
    if ($selected.Count -eq 0) { return }

    $argsString = ($selected | ForEach-Object { $_.Tag }) -join " "
    $argsString += " /Lang=$global:Lang"
	$global:IsApplying = $true
	Close-WindowAnimated $window
	$proc = Start-Process cmd.exe -ArgumentList "/c call `"$batPath`" $argsString" -Verb RunAs -PassThru
})

$mainBorder.Child = $root
$window.Content = $mainBorder
Set-FadeIn $window

if ($ShowReboot) {
    Show-RebootPrompt
} else {
    Set-FadeIn $window
    $window.ShowDialog() | Out-Null
}

if (-not $global:IsApplying) {
    Start-Process "cmd.exe" -ArgumentList "/c timeout /t 2 >nul & rmdir /s /q `"$PSScriptRoot`"" -WindowStyle Hidden
}

