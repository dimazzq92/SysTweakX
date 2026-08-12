import os

gui_path = r"C:\Users\dima\.gemini\antigravity\scratch\WinClick\GUI.ps1"
with open(gui_path, "r", encoding="utf-8") as f:
    content = f.read()

with open(gui_path, "w", encoding="utf-8-sig") as f:
    f.write(content)

print("Added BOM to GUI.ps1")
