import os

readme_path = r"C:\Users\dima\.gemini\antigravity\scratch\WinClick\README.md"
with open(readme_path, "r", encoding="utf-8") as f:
    ru_content = f.read()

en_content = """<a name="english"></a>
<div align="center">

# SysTweakX
**Powerful setup and optimization of Windows 11 in a few clicks!**

<table style="border: none; margin: 0 auto;">
  <tr>
    <td align="center" width="50%"><b>🚀 Downloads</b></td>
    <td align="center" width="50%"><b>🛡️ Status</b></td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://github.com/dimazzq92/SysTweakX/releases/download/Release/SysTweakX.exe">
        <img src="https://img.shields.io/github/downloads/dimazzq92/SysTweakX/Release/total?style=for-the-badge&label=SysTweakX&color=0078D4&logo=windows">
      </a>
    </td>
    <td align="center">
      <img src="https://img.shields.io/badge/Version-2.1%20Pro-4B5563?style=for-the-badge">
    </td>
  </tr>
</table>

</div>

---

> [!CAUTION]
> **This program is designed for deep system optimization.**  
> If run on a working/configured OS, you take full responsibility for any possible issues. It is highly recommended to use this on a fresh Windows installation.

> [!WARNING]
> Recommended OS: **Windows 11 Pro (25H2+)**. Internet connection should be disabled to seamlessly remove built-in telemetry components and Windows Defender.

> [!TIP]
> **Ideal Workflow:** Install Windows 11 without Internet ➔ Configure and run SysTweakX ➔ Wait ➔ Enjoy a clean system with classic interface and no telemetry.

---

<h2 align="center">📋 Features and Capabilities</h2>

<details>
<summary><b>✨ [NEW] Advanced Visual Tweaks</b></summary>
<br>

- **Classic Context Menu (Win10):** Restores the familiar right-click context menu without "Show more options".
- **Left-Aligned Taskbar:** Familiar Start Menu placement for a classic experience.
- **Interface:** Dark theme, blue folders. Disabled icon drop shadows and lock screen.
- **Tray and Taskbar:** Seconds and date in the system tray, "End task" option, removal of unnecessary icons (Search, Widgets).
</details>

<details>
<summary><b>🛡️ [NEW] Privacy and Anti-Telemetry</b></summary>
<br>

- **Block Telemetry (hosts):** Prevents Windows from sending diagnostic data to `vortex.data.microsoft.com` and `telemetry.microsoft.com` servers.
- **Hide Real TTL:** Essential when sharing the Internet from a smartphone to a PC.
- **Set Cloudflare DNS (1.1.1.1)** on Wi-Fi adapters.
</details>

<details>
<summary><b>🗑️ Deep System Cleanup</b></summary>
<br>

- **Remove Windows Update files:** Clears downloaded Windows updates.
- **Remove Microsoft Store cache:** Helps with app download errors from the store.
- **Clean WinSxS Storage:** Removes obsolete and superseded OS component versions.
- **Remove Junk Folders on C: drive:** Deletes `Windows.old`, `PerfLogs`, and `inetpub`.
- **Remove all UWP apps:** Cleans up all unnecessary preinstalled applications.
- **Remove OneDrive and Edge.**
</details>

<details>
<summary><b>⚙️ Optimization Parameters</b></summary>
<br>

- Disable Hibernation and Reserved Storage.
- Disable System Restore Points.
- Delayed start for automatic services and minimized system logging.
- Speed up folder opening.
- **Disable VBS and HVCI** (Noticeably increases performance on AMD processors).
- Set "Ultimate Performance" power plan.
- Disable Game DVR and the "Resume" feature (Frees up RAM).
</details>

<details>
<summary><b>🔄 Windows Update</b></summary>
<br>

- Disable automatic updates and driver installation from Windows Update.
- Disable Malicious Software Removal Tool updates.
- Pause updates until 07.07.2077.
</details>

<details>
<summary><b>🛠️ System Tweaks</b></summary>
<br>

- **Disable UAC:** Disables User Account Control.
- **Enable Built-in Administrator Account:** All programs run with admin rights by default.
- **Force kill frozen applications.**
</details>

<details>
<summary><b>📥 Install Components</b></summary>
<br>

- **Install Drivers:** Installs drivers from the `Drivers` folder on the Desktop (skipped if the folder does not exist).
- **Install Visual C++ 2005-2022** and **DirectX 9-11**.
</details>

<details>
<summary><b>💿 System Compression</b></summary>
<br>

- Maximum compression of system files (CompactOS).
- Maximum compression of system and program files.
  > [!WARNING]
  > On systems with slow drives or a weak CPU, this process can take a significant amount of time!
</details>

---
<div align="center">
<b>Created for flawless performance. Enjoy using SysTweakX! 🚀</b>
</div>
"""

new_header = """<div align="center">
<a href="#русский">🇷🇺 Русский</a> | <a href="#english">🇬🇧 English</a>
</div>

<a name="русский"></a>
"""

if "<a href=\"#русский\">" not in ru_content:
    full_content = new_header + ru_content + "\n\n---\n\n" + en_content
else:
    full_content = ru_content

with open(readme_path, "w", encoding="utf-8") as f:
    f.write(full_content)

print("Done")
