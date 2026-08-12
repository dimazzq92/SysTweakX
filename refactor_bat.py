import os
import re

bat_path = r"C:\Users\dima\.gemini\antigravity\scratch\WinClick\SysTweakX.bat"
with open(bat_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace the loop argument parsing
loop_old = """:loop
    if "%~1" == "" (
        start /b "" Helper /Overlay
        chcp 866>nul
        powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0GUI.ps1" -ShowReboot
        chcp 65001 >nul
        exit
    )
    set arg=%~1"""

loop_new = """:loop
    if "%~1" == "" (
        start /b "" Helper /Overlay
        chcp 866>nul
        powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0GUI.ps1" -ShowReboot -Lang "!LANG!"
        chcp 65001 >nul
        exit
    )
    set arg=%~1
    if /i "!arg:~0,6!"=="/Lang=" (
        set "LANG=!arg:~6!"
        shift
        goto :loop
    )"""

content = content.replace(loop_old, loop_new)

# Translation dictionary for overlays
translations = {
    "Удаление мусора": "Removing junk files",
    "Удаление предустановленных приложений": "Removing preinstalled apps",
    "Удаление браузера Edge": "Removing Edge browser",
    "Удаление компонента WebView2": "Removing WebView2 component",
    "Удаление Защитника Windows": "Removing Windows Defender",
    "Удаление дополнительных компонентов": "Removing optional components",
    "Отключение лишнего в Планировщике задач": "Disabling unnecessary tasks",
    "Оптимизация параметров": "Optimizing system parameters",
    "Настройка Центра обновления Windows": "Configuring Windows Update",
    "Применение полезных твиков": "Applying useful tweaks",
    "Установка драйверов": "Installing drivers",
    "Установка DirectX 9-11": "Installing DirectX 9-11",
    "Установка Visual C++": "Installing Visual C++",
    "Установка визуальных твиков": "Applying visual tweaks",
    "Сжатие системных файлов": "Compressing system files",
    "Сжатие системных и программных файлов": "Compressing system and program files",
    "Утилита предназначена для Windows 11": "This utility is intended for Windows 11",
    "ПК будет перезагружен через несколько минут...": "PC will reboot in a few minutes..."
}

def replace_overlay(match):
    full_match = match.group(0)
    ru_text = match.group(1)
    if ru_text in translations:
        en_text = translations[ru_text]
        return f'if "!LANG!"=="EN" ( start /b "" Helper /Overlay "{en_text}" /Font "Bahnschrift" /Size "40" ) else ( start /b "" Helper /Overlay "{ru_text}" /Font "Bahnschrift" /Size "40" )'
    return full_match

content = re.sub(r'start /b "" Helper /Overlay "([^"]+)" /Font "Bahnschrift" /Size "40"', replace_overlay, content)
content = re.sub(r'start /b "" Helper /Overlay "([^"]+)" /Font "Bahnschrift Bold" /Size "40"', lambda m: replace_overlay(m).replace('"Bahnschrift"', '"Bahnschrift Bold"'), content)

with open(bat_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Done")
