import re

bat_path = r"C:\Users\dima\.gemini\antigravity\scratch\WinClick\SysTweakX.bat"
with open(bat_path, "r", encoding="utf-8") as f:
    content = f.read()

# Fix line 523
admin_str_ru = "Программа не запущена от Администратора...\\n\\nПерезапускаем..."
admin_str_en = "Program is not running as Administrator...\\n\\nRestarting..."
old_523 = f'start /b "" Helper /Overlay "{admin_str_ru}" /Font "Bahnschrift" /Size "40"'
new_523 = f'if "!LANG!"=="EN" ( start /b "" Helper /Overlay "{admin_str_en}" /Font "Bahnschrift" /Size "40" ) else ( start /b "" Helper /Overlay "{admin_str_ru}" /Font "Bahnschrift" /Size "40" )'
content = content.replace(old_523, new_523)

# Fix line 735 syntax
old_735 = 'if !build! LSS 22000 if "!LANG!"=="EN" ( start /b "" Helper /Overlay "This utility is intended for Windows 11" /Font "Bahnschrift" /Size "40" ) else ( start /b "" Helper /Overlay "Утилита предназначена для Windows 11" /Font "Bahnschrift" /Size "40" ) && Helper /HideConsole && timeout /t 4 /nobreak >nul && start /b "" Helper /Overlay && exit'
new_735 = 'if !build! LSS 22000 ( if "!LANG!"=="EN" ( start /b "" Helper /Overlay "This utility is intended for Windows 11" /Font "Bahnschrift" /Size "40" ) else ( start /b "" Helper /Overlay "Утилита предназначена для Windows 11" /Font "Bahnschrift" /Size "40" ) ) && Helper /HideConsole && timeout /t 4 /nobreak >nul && start /b "" Helper /Overlay && exit'
content = content.replace(old_735, new_735)

with open(bat_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Done")
