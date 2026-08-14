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

# ================= ПУТИ =================
$batPath = Join-Path $PSScriptRoot "SysTweakX.bat"
$workDir = Join-Path $PSScriptRoot "Work"

# ================= ЛОКАЛИЗАЦИЯ =================
if ([string]::IsNullOrEmpty($Lang)) {
    $global:Lang = if ((Get-UICulture).TwoLetterISOLanguageName -eq "ru") { "RU" } else { "EN" }
} else {
    $global:Lang = $Lang
}

$loc = @{
    "RU" = @{
        "AppTitle"        = "SysTweakX"
        "AppSubtitle"     = "v3.0 Pro • Windows 11 25H2 Edition"
        "RebootTitle"     = "Настройка успешно завершена!`n`nПерезагрузить компьютер сейчас?"
        "Yes"             = "ДА"
        "No"              = "НЕТ"
        "Optimize"        = "ПРИМЕНИТЬ ТВCamp"
        "OptimizeBtn"     = "ОПТИМИЗИРОВАТЬ"
        "SelectedCount"   = "Выбрано: {0} из {1} твиков"
        "SearchPlaceholder" = "Поиск твиков..."
        "LangToggle"      = "EN"

        # Пресеты
        "Preset_All"      = "Выбрать всё"
        "Preset_None"     = "Снять всё"
        "Preset_Rec"      = "⭐ Рекомендуемый"
        "Preset_Game"     = "🎮 Игровой"
        "Preset_Privacy"  = "🔒 Приватность"
        "Preset_Clean"    = "🧹 Очистка"

        # Категории (Sidebar)
        "Cat_All"         = "📋 Все твики"
        "Cat_Privacy"     = "🛡️ Приватность и AI"
        "Cat_Performance" = "⚡ Производительность"
        "Cat_Interface"   = "🎨 Интерфейс и Панель"
        "Cat_Cleanup"     = "🗑️ Очистка и Удаление"
        "Cat_Updates"     = "🔄 Обновления и Службы"
        "Cat_Runtimes"    = "🧰 Драйверы и Сжатие"

        # 1. Приватность и AI (25H2)
        "Twk_Recall"           = "Отключить Windows Recall (AI снимки экрана)"
        "Twk_Copilot"          = "Отключить Windows Copilot и кнопку Copilot"
        "Twk_BingSearch"       = "Отключить поиск Bing и веб-результаты в Пуске"
        "Twk_Spotlight"        = "Отключить Windows Spotlight и промо-материалы"
        "Twk_Hosts"            = "Блокировка телеметрии Microsoft (hosts)"
        "Twk_Tasks"            = "Отключить задачи телеметрии и сбора данных"
        "Twk_AdId"             = "Отключить рекламный идентификатор (Advertising ID)"
        "Twk_ActivityHistory"  = "Отключить журнал действий (Activity History)"
        "Twk_Notif"            = "Отключить назойливые подсказки и рекламу в ОС"
        "Twk_TTL"              = "Скрыть реальный TTL (раздача интернета с телефона)"
        "Twk_DNS"              = "Установить быстрый DNS Cloudflare (1.1.1.1)"

        # 2. Производительность и Гейминг
        "Twk_HAGS"             = "Включить планирование GPU (HAGS)"
        "Twk_GameDVR"          = "Отключить GameDVR и оптимизировать Game Mode"
        "Twk_NetThrottling"    = "Отключить Network Throttling (снижение пинга)"
        "Twk_UltPerf"          = "Схема питания «Максимальная производительность»"
        "Twk_DisableVBS"       = "Отключить VBS и HVCI (прирост FPS в играх)"
        "Twk_Hibernate"        = "Отключить Гибернацию (освобождает место на C:)"
        "Twk_ResStorage"       = "Отключить Зарезервированное хранилище (7+ ГБ)"
        "Twk_RestorePts"       = "Отключить Точки восстановления системы"
        "Twk_FastFolder"       = "Ускорить открытие папок (отключить авто-поиск типов)"
        "Twk_KillFreeze"       = "Принудительно закрывать зависшие программы"
        "Twk_DelayedSvc"       = "Отложенный запуск автоматических служб"
        "Twk_SvcSplit"         = "Увеличить порог разделения процессов служб (SVC Split)"
        "Twk_BoostIcon"        = "Увеличить кэш иконок Проводника"
        "Twk_SysLog"           = "Минимизировать системные отчеты и дампы"
        "Twk_Resume"           = "Отключить функцию «Возобновить» (экономия ОЗУ)"

        # 3. Интерфейс и Панель задач
        "Twk_ClassMenu"        = "Классическое контекстное меню (стиль Win10)"
        "Twk_LeftTask"         = "Выравнивание Панели задач по левому краю"
        "Twk_DarkTheme"        = "Включить тёмную тему системы и приложений"
        "Twk_EndTask"          = "Пункт «Завершить задачу» по правому клику в Панели"
        "Twk_RmTaskIcon"       = "Скрыть лишние значки (Поиск, Виджеты, Copilot)"
        "Twk_HideRec"          = "Скрыть раздел «Рекомендуем» в меню Пуск"
        "Twk_StartSet"         = "Закрепить значок «Параметры» в меню Пуск"
        "Twk_ExplPC"           = "Открывать Проводник на «Этот компьютер»"
        "Twk_ShowExt"          = "Всегда показывать расширения файлов и скрытые папки"
        "Twk_Home"             = "Удалить раздел «Главная» из Проводника"
        "Twk_Gallery"          = "Удалить раздел «Галерея» из Проводника"
        "Twk_Network"          = "Удалить раздел «Сеть» из Проводника"
        "Twk_WallQual"         = "Отключить сжатие качества обоев рабочего стола"
        "Twk_RmLock"           = "Отключить экран блокировки"
        "Twk_NoIconShad"       = "Убрать тени под значками на Рабочем столе"
        "Twk_TraySec"          = "Показывать секунды в часах трея"
        "Twk_TrayDate"         = "Показывать день недели и дату в трее"
        "Twk_BlueIcon"         = "Установить кастомные синие иконки папок"
        "Twk_Wall"             = "Установить стильные обои SysTweakX"
        "Twk_Icaros"           = "Расширенные эскизы видео и аудио (Icaros)"

        # 4. Очистка и Удаление
        "Twk_UWP"              = "Удалить встроенные UWP-приложения (мусор)"
        "Twk_OneDrive"         = "Полностью удалить Microsoft OneDrive"
        "Twk_Edge"             = "Удалить браузер Microsoft Edge"
        "Twk_WebView"          = "Удалить Edge WebView2"
        "Twk_Defender"         = "Отключить Защитник Windows (DefenderKiller)"
        "Twk_Components"       = "Удалить неиспользуемые компоненты Windows"
        "Twk_Updates"          = "Очистить кэш загруженных файлов обновлений"
        "Twk_StoreCache"       = "Очистить кэш Microsoft Store"
        "Twk_ExplorerCache"    = "Очистить кэш эскизов и историю Проводника"
        "Twk_WinSxS"           = "Глубокая очистка хранилища компонентов WinSxS"
        "Twk_JunkFolders"      = "Удалить папки Windows.old, PerfLogs, inetpub"
        "Twk_OldDrivers"       = "Очистить старые дубликаты драйверов"
        "Twk_ShellBags"        = "Очистить кэш истории папок (ShellBags)"
        "Twk_RemoteAssist"     = "Удалить Помощника по удаленному подключению"
        "Twk_StartMenu"        = "Очистить пустые папки в меню Пуск"

        # 5. Обновления и Службы
        "Twk_NoAutoUpd"        = "Запретить автоматические обновления Windows"
        "Twk_WUDrivers"        = "Запретить установку драйверов через Центр обновлений"
        "Twk_DefUpdates"       = "Запретить обновления программы удаления вредоносных ПО"
        "Twk_PauseUpd"         = "Установить паузу обновлений до 07.07.2077"
        "Twk_DeliveryOpt"      = "Отключить фоновую раздачу обновлений (Delivery Opt)"
        "Twk_UAC"              = "Отключить UAC (Контроль учетных записей)"
        "Twk_Admin"            = "Активировать встроенного Администратора"
        "Twk_Region"           = "Снять региональные ограничения (Integrated Services)"
        "Twk_Remote"           = "Отключить Удаленный помощник"
        "Twk_Sticky"           = "Отключить залипание клавиш при 5-кратном Shift"

        # 6. Драйверы и Сжатие
        "Twk_VC"               = "Установить Visual C++ Redistributable (2005-2022 AIO)"
        "Twk_DX"               = "Установить библиотеки DirectX 9-11"
        "Twk_InstallDrv"       = "Установить драйверы из папки Drivers на Рабочем столе"
        "Twk_CompOS"           = "Максимальное сжатие системных файлов (CompactOS)"
        "Twk_CompDrive"        = "Сжатие системного диска и программных файлов"
    }

    "EN" = @{
        "AppTitle"        = "SysTweakX"
        "AppSubtitle"     = "v3.0 Pro • Windows 11 25H2 Edition"
        "RebootTitle"     = "Optimization Complete!`n`nRestart computer now?"
        "Yes"             = "YES"
        "No"              = "NO"
        "Optimize"        = "APPLY TWEAKS"
        "OptimizeBtn"     = "OPTIMIZE NOW"
        "SelectedCount"   = "Selected: {0} of {1} tweaks"
        "SearchPlaceholder" = "Search tweaks..."
        "LangToggle"      = "RU"

        # Presets
        "Preset_All"      = "Select All"
        "Preset_None"     = "Deselect All"
        "Preset_Rec"      = "⭐ Recommended"
        "Preset_Game"     = "🎮 Gaming"
        "Preset_Privacy"  = "🔒 Privacy"
        "Preset_Clean"    = "🧹 Deep Clean"

        # Categories
        "Cat_All"         = "📋 All Tweaks"
        "Cat_Privacy"     = "🛡️ Privacy & AI"
        "Cat_Performance" = "⚡ Performance"
        "Cat_Interface"   = "🎨 UI & Taskbar"
        "Cat_Cleanup"     = "🗑️ Cleanup & Debloat"
        "Cat_Updates"     = "🔄 Updates & Services"
        "Cat_Runtimes"    = "🧰 Runtimes & More"

        # 1. Privacy & AI (25H2)
        "Twk_Recall"           = "Disable Windows Recall (AI snapshots)"
        "Twk_Copilot"          = "Disable Windows Copilot & Copilot Key"
        "Twk_BingSearch"       = "Disable Bing search & web results in Start"
        "Twk_Spotlight"        = "Disable Windows Spotlight & promoted suggestions"
        "Twk_Hosts"            = "Block Microsoft telemetry via hosts"
        "Twk_Tasks"            = "Disable telemetry & diagnostic scheduled tasks"
        "Twk_AdId"             = "Disable Advertising ID for personalized ads"
        "Twk_ActivityHistory"  = "Disable Activity History tracking"
        "Twk_Notif"            = "Disable tips, tricks and suggested notifications"
        "Twk_TTL"              = "Hide real TTL (hotspot tethering bypass)"
        "Twk_DNS"              = "Set fast Cloudflare DNS (1.1.1.1)"

        # 2. Performance & Gaming
        "Twk_HAGS"             = "Enable Hardware-Accelerated GPU Scheduling (HAGS)"
        "Twk_GameDVR"          = "Disable GameDVR & optimize Game Mode"
        "Twk_NetThrottling"    = "Disable Network Throttling (lower game latency)"
        "Twk_UltPerf"          = "Enable Ultimate Performance Power Plan"
        "Twk_DisableVBS"       = "Disable VBS and HVCI (increase FPS in games)"
        "Twk_Hibernate"        = "Disable Hibernation (free up C: drive space)"
        "Twk_ResStorage"       = "Disable Reserved Storage (7+ GB)"
        "Twk_RestorePts"       = "Disable System Restore Points"
        "Twk_FastFolder"       = "Speed up folder opening (disable auto-template)"
        "Twk_KillFreeze"       = "Force kill hung applications immediately"
        "Twk_DelayedSvc"       = "Delayed start for auto services"
        "Twk_SvcSplit"         = "Increase SVC Process Split threshold"
        "Twk_BoostIcon"        = "Increase Explorer Icon Cache size"
        "Twk_SysLog"           = "Minimize system error reports & crash dumps"
        "Twk_Resume"           = "Disable Resume feature (free up RAM)"

        # 3. UI & Taskbar
        "Twk_ClassMenu"        = "Classic Context Menu (Win10 style)"
        "Twk_LeftTask"         = "Align Taskbar to left"
        "Twk_DarkTheme"        = "Enable dark system & app theme"
        "Twk_EndTask"          = "Enable 'End Task' option on Taskbar right-click"
        "Twk_RmTaskIcon"       = "Remove useless Taskbar icons (Search, Widgets, Copilot)"
        "Twk_HideRec"          = "Hide Recommended section in Start Menu"
        "Twk_StartSet"         = "Pin Settings icon to Start Menu"
        "Twk_ExplPC"           = "Open File Explorer to This PC"
        "Twk_ShowExt"          = "Always show file extensions & hidden files"
        "Twk_Home"             = "Remove Home from File Explorer"
        "Twk_Gallery"          = "Remove Gallery from File Explorer"
        "Twk_Network"          = "Remove Network from File Explorer"
        "Twk_WallQual"         = "Disable desktop wallpaper compression"
        "Twk_RmLock"           = "Disable Lock Screen"
        "Twk_NoIconShad"       = "Remove drop shadows on desktop icons"
        "Twk_TraySec"          = "Show seconds in system tray clock"
        "Twk_TrayDate"         = "Show weekday and full date in tray"
        "Twk_BlueIcon"         = "Set custom blue folder icons"
        "Twk_Wall"             = "Set custom SysTweakX wallpaper"
        "Twk_Icaros"           = "Install extended media thumbnails (Icaros)"

        # 4. Cleanup & Debloat
        "Twk_UWP"              = "Remove preinstalled UWP apps (Bloatware)"
        "Twk_OneDrive"         = "Completely remove Microsoft OneDrive"
        "Twk_Edge"             = "Remove Microsoft Edge browser"
        "Twk_WebView"          = "Remove Edge WebView2 runtime"
        "Twk_Defender"         = "Disable Windows Defender (DefenderKiller)"
        "Twk_Components"       = "Remove unused Windows optional components"
        "Twk_Updates"          = "Clean downloaded Windows Update cache"
        "Twk_StoreCache"       = "Clean Microsoft Store cache"
        "Twk_ExplorerCache"    = "Clean thumbnail and Explorer history cache"
        "Twk_WinSxS"           = "Deep clean & optimize WinSxS component store"
        "Twk_JunkFolders"      = "Remove Windows.old, PerfLogs, inetpub folders"
        "Twk_OldDrivers"       = "Remove old duplicate driver packages"
        "Twk_ShellBags"        = "Clear ShellBags folder view history"
        "Twk_RemoteAssist"     = "Remove Remote Assistance feature"
        "Twk_StartMenu"        = "Clean empty folders from Start Menu"

        # 5. Updates & Services
        "Twk_NoAutoUpd"        = "Disable automatic Windows updates"
        "Twk_WUDrivers"        = "Prevent driver updates via Windows Update"
        "Twk_DefUpdates"       = "Disable Malicious Software Removal updates"
        "Twk_PauseUpd"         = "Pause updates until 07.07.2077"
        "Twk_DeliveryOpt"      = "Disable Delivery Optimization P2P uploads"
        "Twk_UAC"              = "Disable UAC (User Account Control)"
        "Twk_Admin"            = "Enable built-in Administrator account"
        "Twk_Region"           = "Unlock Windows 11 regional restrictions"
        "Twk_Remote"           = "Disable Remote Assistance"
        "Twk_Sticky"           = "Disable Sticky Keys shortcut (5x Shift)"

        # 6. Runtimes & Compression
        "Twk_VC"               = "Install Visual C++ Redistributable (2005-2022 AIO)"
        "Twk_DX"               = "Install DirectX 9-11 End-User Runtimes"
        "Twk_InstallDrv"       = "Install drivers from Desktop Drivers folder"
        "Twk_CompOS"           = "Maximum compression of system files (CompactOS)"
        "Twk_CompDrive"        = "Compress system drive and program files"
    }
}

function L([string]$key) {
    if ($loc[$global:Lang].ContainsKey($key)) {
        return $loc[$global:Lang][$key]
    }
    return $key
}

# ================= СПИСОК ВСЕХ ТВCampОВ =================
$categories = @(
    @{
        Key   = "Cat_Privacy"
        Icon  = "🛡️"
        Items = @(
            @("Twk_Recall",          "/DisableRecall",         $true,  "rec,privacy"),
            @("Twk_Copilot",         "/DisableCopilot",        $true,  "rec,privacy"),
            @("Twk_BingSearch",      "/DisableBingSearch",     $true,  "rec,privacy,game"),
            @("Twk_Spotlight",       "/DisableSpotlight",      $true,  "rec,privacy"),
            @("Twk_Hosts",           "/BlockTelemetry",        $true,  "rec,privacy,game"),
            @("Twk_Tasks",           "/DisableTasks",          $true,  "rec,privacy,game"),
            @("Twk_AdId",            "/DisableAdId",           $true,  "rec,privacy"),
            @("Twk_ActivityHistory", "/DisableActivityHistory", $true, "rec,privacy"),
            @("Twk_Notif",           "/DisableNotificationsAds",$true, "rec,privacy"),
            @("Twk_TTL",             "/TTL",                   $false, "privacy"),
            @("Twk_DNS",             "/DNS",                   $false, "privacy")
        )
    },
    @{
        Key   = "Cat_Performance"
        Icon  = "⚡"
        Items = @(
            @("Twk_HAGS",            "/EnableHAGS",            $true,  "rec,game"),
            @("Twk_GameDVR",         "/DisableGameDVR",        $true,  "rec,game"),
            @("Twk_NetThrottling",   "/DisableNetThrottling",  $true,  "rec,game"),
            @("Twk_UltPerf",         "/UltimatePerformance",   $true,  "rec,game"),
            @("Twk_DisableVBS",      "/DisableVBS",            $true,  "rec,game"),
            @("Twk_FastFolder",      "/FastFolders",           $true,  "rec,game"),
            @("Twk_KillFreeze",      "/KillFreezeApps",        $true,  "rec,game"),
            @("Twk_DelayedSvc",      "/DelayedServices",       $true,  "rec,game"),
            @("Twk_SvcSplit",        "/SvcSplit",              $true,  "rec,game"),
            @("Twk_BoostIcon",       "/BoostIconCache",        $true,  "rec"),
            @("Twk_SysLog",          "/SystemLog",             $true,  "rec"),
            @("Twk_Hibernate",       "/DisableHibernate",      $false, "clean"),
            @("Twk_ResStorage",      "/DisableReservedStorage",$true,  "clean,rec"),
            @("Twk_RestorePts",      "/DisableRestorePoints",  $false, ""),
            @("Twk_Resume",          "/DisableResume",         $false, "game")
        )
    },
    @{
        Key   = "Cat_Interface"
        Icon  = "🎨"
        Items = @(
            @("Twk_ClassMenu",       "/ClassicContextMenu",    $true,  "rec"),
            @("Twk_LeftTask",        "/LeftTaskbar",           $false, "rec"),
            @("Twk_DarkTheme",       "/DarkTheme",             $true,  "rec"),
            @("Twk_EndTask",         "/TaskbarEndTask",        $true,  "rec"),
            @("Twk_RmTaskIcon",      "/RemoveTaskbarIcons",    $true,  "rec,game"),
            @("Twk_HideRec",         "/HideRecommended",       $true,  "rec"),
            @("Twk_StartSet",        "/StartSettingsIcon",     $true,  "rec"),
            @("Twk_ExplPC",          "/ExplorerThisPC",        $true,  "rec"),
            @("Twk_ShowExt",         "/ShowExtensions",        $true,  "rec"),
            @("Twk_Home",            "/RemoveHome",            $false, ""),
            @("Twk_Gallery",         "/RemoveGallery",         $true,  "rec"),
            @("Twk_Network",         "/RemoveNetwork",         $false, ""),
            @("Twk_WallQual",        "/WallpaperQuality",      $true,  "rec"),
            @("Twk_RmLock",          "/RemoveLockScreen",      $false, "rec"),
            @("Twk_NoIconShad",      "/NoIconShadow",          $false, ""),
            @("Twk_TraySec",         "/TraySeconds",           $false, ""),
            @("Twk_TrayDate",        "/TrayDate",              $false, ""),
            @("Twk_BlueIcon",        "/BlueIcons",             $false, ""),
            @("Twk_Wall",            "/SetWallpaper",          $false, ""),
            @("Twk_Icaros",          "/Icaros",                $false, "")
        )
    },
    @{
        Key   = "Cat_Cleanup"
        Icon  = "🗑️"
        Items = @(
            @("Twk_Updates",         "/RemoveUpdateFiles",     $true,  "rec,clean"),
            @("Twk_StoreCache",      "/RemoveStoreCache",      $true,  "rec,clean"),
            @("Twk_ExplorerCache",   "/RemoveExplorerCache",   $true,  "rec,clean"),
            @("Twk_JunkFolders",     "/RemoveJunkFolders",     $true,  "rec,clean"),
            @("Twk_WinSxS",          "/CleanWinSxS",           $false, "clean"),
            @("Twk_OldDrivers",      "/RemoveOldDrivers",      $false, "clean"),
            @("Twk_ShellBags",       "/RemoveShellBags",       $false, "clean"),
            @("Twk_StartMenu",       "/CleanStartMenu",        $true,  "clean"),
            @("Twk_UWP",             "/RemoveAppx",            $false, "clean,privacy"),
            @("Twk_OneDrive",        "/RemoveOneDrive",        $false, "clean,privacy"),
            @("Twk_Edge",            "/RemoveEdge",            $false, "clean,privacy"),
            @("Twk_WebView",         "/RemoveEdgeWebView",     $false, ""),
            @("Twk_Defender",        "/RemoveDefender",        $false, ""),
            @("Twk_Components",      "/RemoveComponents",      $false, "clean"),
            @("Twk_RemoteAssist",    "/RemoveRemoteAssistant", $false, "privacy")
        )
    },
    @{
        Key   = "Cat_Updates"
        Icon  = "🔄"
        Items = @(
            @("Twk_DeliveryOpt",     "/DisableDeliveryOpt",    $true,  "rec,game,privacy"),
            @("Twk_NoAutoUpd",       "/DisableAutoUpdates",    $false, ""),
            @("Twk_WUDrivers",       "/DisableWUDrivers",      $false, "game"),
            @("Twk_DefUpdates",      "/DisableDefenderUpdates",$false, ""),
            @("Twk_PauseUpd",        "/PauseUpdates",          $false, ""),
            @("Twk_UAC",             "/DisableUAC",            $false, ""),
            @("Twk_Admin",           "/EnableAdmin",           $false, ""),
            @("Twk_Region",          "/UnlockRegion",          $true,  "rec"),
            @("Twk_Remote",          "/DisableRemote",         $true,  "rec,privacy"),
            @("Twk_Sticky",          "/DisableStickyKeys",     $true,  "rec,game")
        )
    },
    @{
        Key   = "Cat_Runtimes"
        Icon  = "🧰"
        Items = @(
            @("Twk_VC",              "/InstallVC",             $false, "rec"),
            @("Twk_DX",              "/InstallDX",             $false, "rec"),
            @("Twk_InstallDrv",      "/InstallDrivers",        $false, ""),
            @("Twk_CompOS",          "/CompressOS",            $false, "clean"),
            @("Twk_CompDrive",       "/CompressDrive",         $false, "")
        )
    }
)

# ================= ХЕЛПЕРЫ ЛОКАЛИЗАЦИИ UI =================
$global:locElements = [System.Collections.Generic.List[PSObject]]::new()

function Register-Loc($element, [string]$key, [string]$prop = "Content") {
    $global:locElements.Add([PSCustomObject]@{
        Element  = $element
        Key      = $key
        Property = $prop
    })
    Update-SingleLoc $element $key $prop
}

function Update-SingleLoc($el, [string]$key, [string]$prop) {
    $text = L $key
    if ($prop -eq "Content" -and ($el -is [System.Windows.Controls.ContentControl])) {
        $el.Content = $text
    } elseif ($prop -eq "Text" -and ($el -is [System.Windows.Controls.TextBlock] -or $el -is [System.Windows.Controls.TextBox])) {
        $el.Text = $text
    } elseif ($prop -eq "ToolTip") {
        $el.ToolTip = $text
    }
}

function Update-AllLanguageUI {
    foreach ($item in $global:locElements) {
        Update-SingleLoc $item.Element $item.Key $item.Property
    }
    Update-SummaryCount
}

# ================= ЦВЕТА И СТИЛИ =================
$bgBrush         = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(15, 17, 21))
$sidebarBgBrush  = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(20, 24, 30))
$cardBgBrush     = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(26, 31, 39))
$cardHoverBrush  = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(34, 41, 52))
$cardActiveBrush = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(30, 38, 48))
$accentBrush     = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(0, 120, 212))
$accentHoverBrush= [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(30, 144, 255))
$borderBrush     = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(45, 52, 64))
$textPrimary     = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(240, 243, 246))
$textSecondary   = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(140, 150, 165))
$textMuted       = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(90, 100, 115))

# ================= АНИМАЦИИ =================
function Set-FadeIn($win) {
    $win.Opacity = 0
    $win.Add_Loaded({
        $fadeIn = [System.Windows.Media.Animation.DoubleAnimation]::new(0, 1, [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(250)))
        $fadeIn.EasingFunction = [System.Windows.Media.Animation.QuadraticEase]::new()
        $this.BeginAnimation([System.Windows.Window]::OpacityProperty, $fadeIn)
    })
}

function Close-WindowAnimated($win) {
    if ($win.Tag -eq "Closing") { return }
    $win.Tag = "Closing"
    $fadeOut = [System.Windows.Media.Animation.DoubleAnimation]::new($win.Opacity, 0, [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(200)))
    $fadeOut.Add_Completed({ $win.Close() }.GetNewClosure())
    $win.BeginAnimation([System.Windows.Window]::OpacityProperty, $fadeOut)
}

# ================= ОКНО ПЕРЕЗАГРУЗКИ =================
function Show-RebootPrompt {
    $doneWin = [System.Windows.Window]::new()
    $doneWin.Width = 320; $doneWin.Height = 160; $doneWin.AllowsTransparency = $true; $doneWin.WindowStyle = "None"
    $doneWin.WindowStartupLocation = "CenterScreen"; $doneWin.Topmost = $true; $doneWin.Background = [System.Windows.Media.Brushes]::Transparent
    
    $doneBorder = [System.Windows.Controls.Border]::new()
    $doneBorder.Background = $sidebarBgBrush; $doneBorder.CornerRadius = 14; $doneBorder.BorderBrush = $accentBrush; $doneBorder.BorderThickness = 1.5
    $doneBorder.Padding = [System.Windows.Thickness]::new(20)

    $doneStack = [System.Windows.Controls.StackPanel]::new()
    $doneStack.VerticalAlignment = "Center"
    
    $doneText = [System.Windows.Controls.TextBlock]::new()
    Register-Loc $doneText "RebootTitle" "Text"
    $doneText.Foreground = $textPrimary; $doneText.TextAlignment = "Center"; $doneText.FontSize = 13
    $doneText.FontFamily = "Segoe UI Variable Display, Segoe UI, Bahnschrift"; $doneText.FontWeight = [System.Windows.FontWeights]::SemiBold
    $doneText.TextWrapping = [System.Windows.TextWrapping]::Wrap

    $btnP = [System.Windows.Controls.StackPanel]::new(); $btnP.Orientation = "Horizontal"; $btnP.HorizontalAlignment = "Center"; $btnP.Margin = [System.Windows.Thickness]::new(0,16,0,0)
    
    $bR = [System.Windows.Controls.Button]::new()
    Register-Loc $bR "Yes"
    $bR.Width = 90; $bR.Height = 32; $bR.Background = $accentBrush; $bR.Foreground = [System.Windows.Media.Brushes]::White; $bR.FontWeight = [System.Windows.FontWeights]::Bold; $bR.Margin = [System.Windows.Thickness]::new(0,0,10,0)
    $bR.Cursor = [System.Windows.Input.Cursors]::Hand
    $bR.Add_Click({ 
        Close-WindowAnimated $doneWin
        Start-Process "shutdown.exe" -ArgumentList "/r /t 1 /f" -WindowStyle Hidden
    })

    $bC = [System.Windows.Controls.Button]::new()
    Register-Loc $bC "No"
    $bC.Width = 90; $bC.Height = 32; $bC.Background = $cardBgBrush; $bC.Foreground = $textSecondary; $bC.FontWeight = [System.Windows.FontWeights]::SemiBold
    $bC.Cursor = [System.Windows.Input.Cursors]::Hand
    $bC.Add_Click({ Close-WindowAnimated $doneWin })

    $btnP.Children.Add($bR) | Out-Null
    $btnP.Children.Add($bC) | Out-Null
    $doneStack.Children.Add($doneText) | Out-Null
    $doneStack.Children.Add($btnP) | Out-Null
    $doneBorder.Child = $doneStack
    $doneWin.Content = $doneBorder
    Set-FadeIn $doneWin
    $doneWin.ShowDialog() | Out-Null
}

if ($ShowReboot) {
    Show-RebootPrompt
    exit
}

# ================= ГЛАВНОЕ ОКНО =================
$window = [System.Windows.Window]::new()
$window.Title = "SysTweakX v3.0 Pro"
$window.Width = 920
$window.Height = 650
$window.MinWidth = 800
$window.MinHeight = 550
$window.AllowsTransparency = $true
$window.WindowStyle = "None"
$window.WindowStartupLocation = "CenterScreen"
$window.Background = [System.Windows.Media.Brushes]::Transparent
$window.FontFamily = "Segoe UI Variable Text, Segoe UI, Bahnschrift, Arial"

$mainBorder = [System.Windows.Controls.Border]::new()
$mainBorder.Background = $bgBrush
$mainBorder.CornerRadius = [System.Windows.CornerRadius]::new(14)
$mainBorder.BorderThickness = [System.Windows.Thickness]::new(1.2)
$mainBorder.BorderBrush = $borderBrush

$mainGrid = [System.Windows.Controls.Grid]::new()
$rowTop = [System.Windows.Controls.RowDefinition]::new(); $rowTop.Height = [System.Windows.GridLength]::new(56, [System.Windows.GridUnitType]::Pixel)
$rowMid = [System.Windows.Controls.RowDefinition]::new(); $rowMid.Height = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
$rowBot = [System.Windows.Controls.RowDefinition]::new(); $rowBot.Height = [System.Windows.GridLength]::new(64, [System.Windows.GridUnitType]::Pixel)
$mainGrid.RowDefinitions.Add($rowTop)
$mainGrid.RowDefinitions.Add($rowMid)
$mainGrid.RowDefinitions.Add($rowBot)

# ----------------- 1. HEADER -----------------
$headerGrid = [System.Windows.Controls.Grid]::new()
$headerGrid.Background = $sidebarBgBrush
$headerGrid.Margin = [System.Windows.Thickness]::new(0)
$headerGrid.Add_MouseDown({ if ($_.LeftButton -eq "Pressed") { $window.DragMove() } })

# Title Left
$titleStack = [System.Windows.Controls.StackPanel]::new()
$titleStack.Orientation = "Horizontal"
$titleStack.VerticalAlignment = "Center"
$titleStack.Margin = [System.Windows.Thickness]::new(20, 0, 0, 0)

$iconBlock = [System.Windows.Controls.TextBlock]::new()
$iconBlock.Text = "⚡"
$iconBlock.FontSize = 20
$iconBlock.VerticalAlignment = "Center"
$iconBlock.Margin = [System.Windows.Thickness]::new(0, 0, 10, 0)

$titleTextStack = [System.Windows.Controls.StackPanel]::new()
$lblTitle = [System.Windows.Controls.TextBlock]::new()
$lblTitle.Text = "SysTweakX"
$lblTitle.Foreground = $textPrimary
$lblTitle.FontSize = 16
$lblTitle.FontWeight = [System.Windows.FontWeights]::Bold

$lblSub = [System.Windows.Controls.TextBlock]::new()
Register-Loc $lblSub "AppSubtitle" "Text"
$lblSub.Foreground = $accentBrush
$lblSub.FontSize = 11
$lblSub.FontWeight = [System.Windows.FontWeights]::SemiBold

$titleTextStack.Children.Add($lblTitle) | Out-Null
$titleTextStack.Children.Add($lblSub) | Out-Null
$titleStack.Children.Add($iconBlock) | Out-Null
$titleStack.Children.Add($titleTextStack) | Out-Null
$headerGrid.Children.Add($titleStack) | Out-Null

# Actions Right
$headerActions = [System.Windows.Controls.StackPanel]::new()
$headerActions.Orientation = "Horizontal"
$headerActions.HorizontalAlignment = "Right"
$headerActions.VerticalAlignment = "Center"
$headerActions.Margin = [System.Windows.Thickness]::new(0, 0, 15, 0)

# Social Links
function Add-HeaderLink($iconName, $url, $tooltip) {
    $btn = [System.Windows.Controls.Border]::new()
    $btn.Width = 28; $btn.Height = 28; $btn.CornerRadius = 6; $btn.Margin = [System.Windows.Thickness]::new(3)
    $btn.Background = [System.Windows.Media.Brushes]::Transparent; $btn.Cursor = [System.Windows.Input.Cursors]::Hand
    $btn.ToolTip = $tooltip
    
    $imgPath = Join-Path $workDir $iconName
    if (Test-Path $imgPath) {
        $img = [System.Windows.Controls.Image]::new()
        $bmp = [System.Windows.Media.Imaging.BitmapImage]::new([Uri]$imgPath)
        $img.Source = $bmp; $img.Width = 16; $img.Height = 16; $img.Opacity = 0.75
        $btn.Child = $img
    }
    $btn.Add_MouseEnter({ $this.Background = $cardHoverBrush; if ($this.Child) { $this.Child.Opacity = 1 } })
    $btn.Add_MouseLeave({ $this.Background = [System.Windows.Media.Brushes]::Transparent; if ($this.Child) { $this.Child.Opacity = 0.75 } })
    $btn.Add_MouseDown({ Start-Process $url }.GetNewClosure())
    return $btn
}

$headerActions.Children.Add((Add-HeaderLink "Telegram.ico" "https://t.me/SysTweakX" "Telegram Community")) | Out-Null
$headerActions.Children.Add((Add-HeaderLink "GitHub.ico" "https://github.com/dimazzq92/SysTweakX" "GitHub Repository")) | Out-Null
$headerActions.Children.Add((Add-HeaderLink "YouTube.ico" "https://youtube.com/@dimazzq" "YouTube Channel")) | Out-Null

# Language Toggle
$btnLang = [System.Windows.Controls.Border]::new()
$btnLang.Width = 36; $btnLang.Height = 26; $btnLang.CornerRadius = 6; $btnLang.Margin = [System.Windows.Thickness]::new(8, 0, 12, 0)
$btnLang.Background = $cardBgBrush; $btnLang.BorderThickness = 1; $btnLang.BorderBrush = $borderBrush
$btnLang.Cursor = [System.Windows.Input.Cursors]::Hand

$txtLang = [System.Windows.Controls.TextBlock]::new()
Register-Loc $txtLang "LangToggle" "Text"
$txtLang.Foreground = $accentBrush; $txtLang.FontWeight = [System.Windows.FontWeights]::Bold; $txtLang.FontSize = 11
$txtLang.HorizontalAlignment = "Center"; $txtLang.VerticalAlignment = "Center"
$btnLang.Child = $txtLang

$btnLang.Add_MouseEnter({ $this.Background = $cardHoverBrush })
$btnLang.Add_MouseLeave({ $this.Background = $cardBgBrush })
$btnLang.Add_MouseDown({
    $global:Lang = if ($global:Lang -eq "RU") { "EN" } else { "RU" }
    Update-AllLanguageUI
})
$headerActions.Children.Add($btnLang) | Out-Null

# Window Controls
$btnMin = [System.Windows.Controls.Border]::new()
$btnMin.Width = 30; $btnMin.Height = 28; $btnMin.CornerRadius = 6; $btnMin.Background = [System.Windows.Media.Brushes]::Transparent
$btnMin.Cursor = [System.Windows.Input.Cursors]::Hand
$txtMin = [System.Windows.Controls.TextBlock]::new(); $txtMin.Text = "─"; $txtMin.Foreground = $textSecondary
$txtMin.HorizontalAlignment = "Center"; $txtMin.VerticalAlignment = "Center"; $txtMin.FontSize = 11
$btnMin.Child = $txtMin
$btnMin.Add_MouseEnter({ $this.Background = $cardHoverBrush; $txtMin.Foreground = $textPrimary })
$btnMin.Add_MouseLeave({ $this.Background = [System.Windows.Media.Brushes]::Transparent; $txtMin.Foreground = $textSecondary })
$btnMin.Add_MouseDown({ $window.WindowState = "Minimized" })
$headerActions.Children.Add($btnMin) | Out-Null

$btnClose = [System.Windows.Controls.Border]::new()
$btnClose.Width = 30; $btnClose.Height = 28; $btnClose.CornerRadius = 6; $btnClose.Background = [System.Windows.Media.Brushes]::Transparent
$btnClose.Cursor = [System.Windows.Input.Cursors]::Hand
$txtClose = [System.Windows.Controls.TextBlock]::new(); $txtClose.Text = "✕"; $txtClose.Foreground = $textSecondary
$txtClose.HorizontalAlignment = "Center"; $txtClose.VerticalAlignment = "Center"; $txtClose.FontSize = 11
$btnClose.Child = $txtClose
$btnClose.Add_MouseEnter({ $this.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(200, 40, 40)); $txtClose.Foreground = [System.Windows.Media.Brushes]::White })
$btnClose.Add_MouseLeave({ $this.Background = [System.Windows.Media.Brushes]::Transparent; $txtClose.Foreground = $textSecondary })
$btnClose.Add_MouseDown({ Close-WindowAnimated $window })
$headerActions.Children.Add($btnClose) | Out-Null

$headerGrid.Children.Add($headerActions) | Out-Null
[System.Windows.Controls.Grid]::SetRow($headerGrid, 0)
$mainGrid.Children.Add($headerGrid) | Out-Null

# ----------------- 2. BODY (SIDEBAR + CONTENT) -----------------
$bodyGrid = [System.Windows.Controls.Grid]::new()
$colSidebar = [System.Windows.Controls.ColumnDefinition]::new(); $colSidebar.Width = [System.Windows.GridLength]::new(210, [System.Windows.GridUnitType]::Pixel)
$colMain    = [System.Windows.Controls.ColumnDefinition]::new(); $colMain.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
$bodyGrid.ColumnDefinitions.Add($colSidebar)
$bodyGrid.ColumnDefinitions.Add($colMain)

# --- SIDEBAR ---
$sidebar = [System.Windows.Controls.Border]::new()
$sidebar.Background = $sidebarBgBrush
$sidebar.BorderThickness = [System.Windows.Thickness]::new(0, 0, 1, 0)
$sidebar.BorderBrush = $borderBrush

$sidebarStack = [System.Windows.Controls.StackPanel]::new()
$sidebarStack.Margin = [System.Windows.Thickness]::new(10, 15, 10, 15)

$global:activeCategory = "Cat_All"
$sidebarButtons = [System.Collections.Generic.List[System.Windows.Controls.Border]]::new()

function Create-SidebarBtn([string]$catKey, [string]$icon, [string]$labelKey) {
    $btn = [System.Windows.Controls.Border]::new()
    $btn.Height = 38; $btn.CornerRadius = 8; $btn.Margin = [System.Windows.Thickness]::new(0, 0, 0, 4)
    $btn.Cursor = [System.Windows.Input.Cursors]::Hand
    $btn.Tag = $catKey
    $btn.Background = if ($catKey -eq "Cat_All") { $accentBrush } else { [System.Windows.Media.Brushes]::Transparent }

    $sp = [System.Windows.Controls.StackPanel]::new()
    $sp.Orientation = "Horizontal"; $sp.VerticalAlignment = "Center"; $sp.Margin = [System.Windows.Thickness]::new(12, 0, 8, 0)

    $ico = [System.Windows.Controls.TextBlock]::new()
    $ico.Text = $icon; $ico.FontSize = 14; $ico.VerticalAlignment = "Center"; $ico.Margin = [System.Windows.Thickness]::new(0, 0, 10, 0)

    $lbl = [System.Windows.Controls.TextBlock]::new()
    Register-Loc $lbl $labelKey "Text"
    $lbl.Foreground = if ($catKey -eq "Cat_All") { [System.Windows.Media.Brushes]::White } else { $textSecondary }
    $lbl.FontSize = 12; $lbl.FontWeight = [System.Windows.FontWeights]::SemiBold
    $lbl.VerticalAlignment = "Center"

    $sp.Children.Add($ico) | Out-Null
    $sp.Children.Add($lbl) | Out-Null
    $btn.Child = $sp

    $btn.Add_MouseEnter({
        if ($this.Tag -ne $global:activeCategory) {
            $this.Background = $cardHoverBrush
            $this.Child.Children[1].Foreground = $textPrimary
        }
    })
    $btn.Add_MouseLeave({
        if ($this.Tag -ne $global:activeCategory) {
            $this.Background = [System.Windows.Media.Brushes]::Transparent
            $this.Child.Children[1].Foreground = $textSecondary
        }
    })
    $btn.Add_MouseDown({
        $global:activeCategory = $this.Tag
        foreach ($sb in $sidebarButtons) {
            if ($sb.Tag -eq $global:activeCategory) {
                $sb.Background = $accentBrush
                $sb.Child.Children[1].Foreground = [System.Windows.Media.Brushes]::White
            } else {
                $sb.Background = [System.Windows.Media.Brushes]::Transparent
                $sb.Child.Children[1].Foreground = $textSecondary
            }
        }
        Filter-Tweaks
    })

    $sidebarButtons.Add($btn)
    return $btn
}

$sidebarStack.Children.Add((Create-SidebarBtn "Cat_All" "📋" "Cat_All")) | Out-Null
foreach ($cat in $categories) {
    $sidebarStack.Children.Add((Create-SidebarBtn $cat.Key $cat.Icon $cat.Key)) | Out-Null
}

$sidebar.Child = $sidebarStack
[System.Windows.Controls.Grid]::SetColumn($sidebar, 0)
$bodyGrid.Children.Add($sidebar) | Out-Null

# --- MAIN CONTENT AREA ---
$contentGrid = [System.Windows.Controls.Grid]::new()
$contentGrid.Margin = [System.Windows.Thickness]::new(16, 12, 16, 10)

$rowTools = [System.Windows.Controls.RowDefinition]::new(); $rowTools.Height = [System.Windows.GridLength]::new(46, [System.Windows.GridUnitType]::Pixel)
$rowCards = [System.Windows.Controls.RowDefinition]::new(); $rowCards.Height = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
$contentGrid.RowDefinitions.Add($rowTools)
$contentGrid.RowDefinitions.Add($rowCards)

# Search & Presets Toolbar
$toolbarGrid = [System.Windows.Controls.Grid]::new()
$colSearch = [System.Windows.Controls.ColumnDefinition]::new(); $colSearch.Width = [System.Windows.GridLength]::new(200, [System.Windows.GridUnitType]::Pixel)
$colPresets = [System.Windows.Controls.ColumnDefinition]::new(); $colPresets.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
$toolbarGrid.ColumnDefinitions.Add($colSearch)
$toolbarGrid.ColumnDefinitions.Add($colPresets)

# Search Box
$searchBorder = [System.Windows.Controls.Border]::new()
$searchBorder.Background = $cardBgBrush; $searchBorder.CornerRadius = 8; $searchBorder.BorderThickness = 1; $searchBorder.BorderBrush = $borderBrush
$searchBorder.Height = 34; $searchBorder.Margin = [System.Windows.Thickness]::new(0, 0, 10, 0)

$searchStack = [System.Windows.Controls.StackPanel]::new(); $searchStack.Orientation = "Horizontal"; $searchStack.VerticalAlignment = "Center"
$searchIcon = [System.Windows.Controls.TextBlock]::new(); $searchIcon.Text = "🔍"; $searchIcon.FontSize = 11; $searchIcon.Margin = [System.Windows.Thickness]::new(8, 0, 6, 0); $searchIcon.Foreground = $textMuted

$searchBox = [System.Windows.Controls.TextBox]::new()
$searchBox.Background = [System.Windows.Media.Brushes]::Transparent; $searchBox.BorderThickness = 0
$searchBox.Foreground = $textPrimary; $searchBox.FontSize = 12; $searchBox.Width = 160
$searchBox.VerticalAlignment = "Center"

$searchBox.Add_TextChanged({ Filter-Tweaks })

$searchStack.Children.Add($searchIcon) | Out-Null
$searchStack.Children.Add($searchBox) | Out-Null
$searchBorder.Child = $searchStack
[System.Windows.Controls.Grid]::SetColumn($searchBorder, 0)
$toolbarGrid.Children.Add($searchBorder) | Out-Null

# Presets Bar
$presetsPanel = [System.Windows.Controls.StackPanel]::new()
$presetsPanel.Orientation = "Horizontal"
$presetsPanel.HorizontalAlignment = "Right"

function Create-PresetBtn([string]$presetKey, [string]$locKey, [string]$tooltip) {
    $btn = [System.Windows.Controls.Border]::new()
    $btn.Height = 32; $btn.CornerRadius = 7; $btn.Margin = [System.Windows.Thickness]::new(3, 0, 3, 0)
    $btn.Background = $cardBgBrush; $btn.BorderThickness = 1; $btn.BorderBrush = $borderBrush
    $btn.Cursor = [System.Windows.Input.Cursors]::Hand; $btn.ToolTip = $tooltip

    $lbl = [System.Windows.Controls.TextBlock]::new()
    Register-Loc $lbl $locKey "Text"
    $lbl.Foreground = $textSecondary; $lbl.FontSize = 11; $lbl.FontWeight = [System.Windows.FontWeights]::SemiBold
    $lbl.Margin = [System.Windows.Thickness]::new(10, 0, 10, 0); $lbl.VerticalAlignment = "Center"
    $btn.Child = $lbl

    $btn.Add_MouseEnter({ $this.Background = $cardHoverBrush; $this.Child.Foreground = $textPrimary })
    $btn.Add_MouseLeave({ $this.Background = $cardBgBrush; $this.Child.Foreground = $textSecondary })
    $btn.Add_MouseDown({
        Apply-Preset $presetKey
    }.GetNewClosure())

    return $btn
}

$presetsPanel.Children.Add((Create-PresetBtn "rec"     "Preset_Rec"     "Recommended for all users")) | Out-Null
$presetsPanel.Children.Add((Create-PresetBtn "game"    "Preset_Game"    "Maximum FPS and low latency")) | Out-Null
$presetsPanel.Children.Add((Create-PresetBtn "privacy" "Preset_Privacy" "Anti-telemetry & anti-spy")) | Out-Null
$presetsPanel.Children.Add((Create-PresetBtn "clean"   "Preset_Clean"   "Deep storage & junk clean")) | Out-Null
$presetsPanel.Children.Add((Create-PresetBtn "all"     "Preset_All"     "Select all tweaks")) | Out-Null
$presetsPanel.Children.Add((Create-PresetBtn "none"    "Preset_None"    "Deselect all tweaks")) | Out-Null

[System.Windows.Controls.Grid]::SetColumn($presetsPanel, 1)
$toolbarGrid.Children.Add($presetsPanel) | Out-Null

[System.Windows.Controls.Grid]::SetRow($toolbarGrid, 0)
$contentGrid.Children.Add($toolbarGrid) | Out-Null

# --- TWEAKS SCROLL AREA (2-COLUMN CARDS) ---
$scrollViewer = [System.Windows.Controls.ScrollViewer]::new()
$scrollViewer.VerticalScrollBarVisibility = "Auto"
$scrollViewer.HorizontalScrollBarVisibility = "Disabled"
$scrollViewer.Margin = [System.Windows.Thickness]::new(0, 6, 0, 0)

$cardsWrap = [System.Windows.Controls.WrapPanel]::new()
$cardsWrap.Orientation = "Horizontal"
$cardsWrap.ItemWidth = 324
$cardsWrap.Margin = [System.Windows.Thickness]::new(0)

$global:allTweakCards = [System.Collections.Generic.List[PSObject]]::new()

foreach ($cat in $categories) {
    foreach ($item in $cat.Items) {
        $locKey    = $item[0]
        $tag       = $item[1]
        $defaultOn = $item[2]
        $presetTags= $item[3]

        $card = [System.Windows.Controls.Border]::new()
        $card.Height = 52
        $card.CornerRadius = 8
        $card.Margin = [System.Windows.Thickness]::new(4)
        $card.Background = $cardBgBrush
        $card.BorderThickness = 1
        $card.BorderBrush = $borderBrush
        $card.Cursor = [System.Windows.Input.Cursors]::Hand

        $cardGrid = [System.Windows.Controls.Grid]::new()
        $colCheck = [System.Windows.Controls.ColumnDefinition]::new(); $colCheck.Width = [System.Windows.GridLength]::new(34, [System.Windows.GridUnitType]::Pixel)
        $colLabel = [System.Windows.Controls.ColumnDefinition]::new(); $colLabel.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
        $cardGrid.ColumnDefinitions.Add($colCheck)
        $cardGrid.ColumnDefinitions.Add($colLabel)

        $cb = [System.Windows.Controls.CheckBox]::new()
        $cb.Tag = $tag
        $cb.IsChecked = $defaultOn
        $cb.VerticalAlignment = "Center"
        $cb.HorizontalAlignment = "Center"
        $cb.Margin = [System.Windows.Thickness]::new(4, 0, 0, 0)

        $txt = [System.Windows.Controls.TextBlock]::new()
        Register-Loc $txt $locKey "Text"
        $txt.Foreground = if ($cb.IsChecked) { $textPrimary } else { $textSecondary }
        $txt.FontSize = 11.5
        $txt.TextWrapping = [System.Windows.TextWrapping]::Wrap
        $txt.VerticalAlignment = "Center"
        $txt.Margin = [System.Windows.Thickness]::new(2, 0, 8, 0)

        $cb.Add_Checked({
            $card.Background = $cardActiveBrush
            $card.BorderBrush = $accentBrush
            $txt.Foreground = $textPrimary
            Update-SummaryCount
        }.GetNewClosure())

        $cb.Add_Unchecked({
            $card.Background = $cardBgBrush
            $card.BorderBrush = $borderBrush
            $txt.Foreground = $textSecondary
            Update-SummaryCount
        }.GetNewClosure())

        $card.Add_MouseDown({
            $cb.IsChecked = -not $cb.IsChecked
        }.GetNewClosure())

        $card.Add_MouseEnter({
            if (-not $cb.IsChecked) { $this.Background = $cardHoverBrush }
        }.GetNewClosure())

        $card.Add_MouseLeave({
            if (-not $cb.IsChecked) { $this.Background = $cardBgBrush }
        }.GetNewClosure())

        if ($cb.IsChecked) {
            $card.Background = $cardActiveBrush
            $card.BorderBrush = $accentBrush
        }

        [System.Windows.Controls.Grid]::SetColumn($cb, 0)
        [System.Windows.Controls.Grid]::SetColumn($txt, 1)
        $cardGrid.Children.Add($cb) | Out-Null
        $cardGrid.Children.Add($txt) | Out-Null
        $card.Child = $cardGrid

        $cardsWrap.Children.Add($card) | Out-Null

        $global:allTweakCards.Add([PSCustomObject]@{
            Card       = $card
            CheckBox   = $cb
            Category   = $cat.Key
            LocKey     = $locKey
            Tag        = $tag
            PresetTags = $presetTags
        })
    }
}

$scrollViewer.Content = $cardsWrap
[System.Windows.Controls.Grid]::SetRow($scrollViewer, 1)
$contentGrid.Children.Add($scrollViewer) | Out-Null

[System.Windows.Controls.Grid]::SetColumn($contentGrid, 1)
$bodyGrid.Children.Add($contentGrid) | Out-Null

[System.Windows.Controls.Grid]::SetRow($bodyGrid, 1)
$mainGrid.Children.Add($bodyGrid) | Out-Null

# ----------------- 3. FOOTER / ACTION BAR -----------------
$footerGrid = [System.Windows.Controls.Grid]::new()
$footerGrid.Background = $sidebarBgBrush
$footerGrid.BorderThickness = [System.Windows.Thickness]::new(0, 1, 0, 0)
$footerGrid.BorderBrush = $borderBrush

$footerStack = [System.Windows.Controls.Grid]::new()
$footerStack.Margin = [System.Windows.Thickness]::new(24, 0, 24, 0)

$colInfo = [System.Windows.Controls.ColumnDefinition]::new(); $colInfo.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
$colBtn  = [System.Windows.Controls.ColumnDefinition]::new(); $colBtn.Width = [System.Windows.GridLength]::new(200, [System.Windows.GridUnitType]::Pixel)
$footerStack.ColumnDefinitions.Add($colInfo)
$footerStack.ColumnDefinitions.Add($colBtn)

$lblCount = [System.Windows.Controls.TextBlock]::new()
$lblCount.Foreground = $textSecondary
$lblCount.FontSize = 13
$lblCount.FontWeight = [System.Windows.FontWeights]::SemiBold
$lblCount.VerticalAlignment = "Center"
[System.Windows.Controls.Grid]::SetColumn($lblCount, 0)
$footerStack.Children.Add($lblCount) | Out-Null

$btnOptimize = [System.Windows.Controls.Border]::new()
$btnOptimize.Height = 40; $btnOptimize.CornerRadius = 8
$btnOptimize.Background = $accentBrush; $btnOptimize.Cursor = [System.Windows.Input.Cursors]::Hand
$btnOptimize.VerticalAlignment = "Center"

$txtOpt = [System.Windows.Controls.TextBlock]::new()
Register-Loc $txtOpt "OptimizeBtn" "Text"
$txtOpt.Foreground = [System.Windows.Media.Brushes]::White; $txtOpt.FontWeight = [System.Windows.FontWeights]::Bold; $txtOpt.FontSize = 13
$txtOpt.HorizontalAlignment = "Center"; $txtOpt.VerticalAlignment = "Center"
$btnOptimize.Child = $txtOpt

$btnOptimize.Add_MouseEnter({ $this.Background = $accentHoverBrush })
$btnOptimize.Add_MouseLeave({ $this.Background = $accentBrush })

$btnOptimize.Add_MouseDown({
    $selected = $global:allTweakCards | Where-Object { $_.CheckBox.IsChecked }
    if ($selected.Count -eq 0) { return }

    $argsString = ($selected | ForEach-Object { $_.Tag }) -join " "
    $argsString += " /Lang=$global:Lang"
    $global:IsApplying = $true
    Close-WindowAnimated $window
    Start-Process cmd.exe -ArgumentList "/c call `"$batPath`" $argsString" -Verb RunAs
})

[System.Windows.Controls.Grid]::SetColumn($btnOptimize, 1)
$footerStack.Children.Add($btnOptimize) | Out-Null

$footerGrid.Children.Add($footerStack) | Out-Null
[System.Windows.Controls.Grid]::SetRow($footerGrid, 2)
$mainGrid.Children.Add($footerGrid) | Out-Null

# ================= ФУНКЦИИ ФИЛЬТРАЦИИ И ПРЕСЕТОВ =================
function Filter-Tweaks {
    $search = $searchBox.Text.Trim().ToLower()
    foreach ($item in $global:allTweakCards) {
        $matchCat = ($global:activeCategory -eq "Cat_All") -or ($item.Category -eq $global:activeCategory)
        $textLocRU = $loc["RU"][$item.LocKey].ToLower()
        $textLocEN = $loc["EN"][$item.LocKey].ToLower()
        $matchSearch = [string]::IsNullOrEmpty($search) -or ($textLocRU -like "*$search*") -or ($textLocEN -like "*$search*") -or ($item.Tag.ToLower() -like "*$search*")

        if ($matchCat -and $matchSearch) {
            $item.Card.Visibility = "Visible"
        } else {
            $item.Card.Visibility = "Collapsed"
        }
    }
}

function Apply-Preset([string]$preset) {
    # Сжатие взаимоисключающее
    $compOS = $global:allTweakCards | Where-Object { $_.Tag -eq "/CompressOS" }
    $compDrive = $global:allTweakCards | Where-Object { $_.Tag -eq "/CompressDrive" }

    foreach ($item in $global:allTweakCards) {
        if ($preset -eq "all") {
            $item.CheckBox.IsChecked = $true
        } elseif ($preset -eq "none") {
            $item.CheckBox.IsChecked = $false
        } else {
            $tags = $item.PresetTags.Split(",")
            $item.CheckBox.IsChecked = ($tags -contains $preset)
        }
    }

    if ($compOS.CheckBox.IsChecked -and $compDrive.CheckBox.IsChecked) {
        $compDrive.CheckBox.IsChecked = $false
    }
    Update-SummaryCount
}

function Update-SummaryCount {
    $total = $global:allTweakCards.Count
    $checked = ($global:allTweakCards | Where-Object { $_.CheckBox.IsChecked }).Count
    $lblCount.Text = [string]::Format((L "SelectedCount"), $checked, $total)
    $btnOptimize.Opacity = if ($checked -gt 0) { 1.0 } else { 0.4 }
    $btnOptimize.IsHitTestVisible = ($checked -gt 0)
}

# ================= ЗАПУСК =================
$mainBorder.Child = $mainGrid
$window.Content = $mainBorder
Set-FadeIn $window
Update-SummaryCount

$window.ShowDialog() | Out-Null

if (-not $global:IsApplying) {
    Start-Process "cmd.exe" -ArgumentList "/c timeout /t 2 >nul & rmdir /s /q `"$PSScriptRoot`"" -WindowStyle Hidden
}
