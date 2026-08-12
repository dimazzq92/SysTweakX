$ErrorActionPreference = "Stop"
Write-Host "Extracting 7zSD.sfx..."
7z x lzma.7z -olzmabin -y
Copy-Item lzmabin\bin\7zSD.sfx -Destination . -Force

Write-Host "Creating archive..."
if (Test-Path app.7z) { Remove-Item app.7z -Force }
7z a app.7z * -x!app.7z -x!lzma.7z -x!lzmabin -x!7zSD.sfx -x!.git -x!.github -x!setup.iss -x!get_logs.ps1 -x!build.ps1 -x!SysTweakX.exe

Write-Host "Writing config.txt with UTF-8 BOM..."
$config = ";!@Install@!UTF-8!`r`nRunProgram=`"powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File GUI.ps1`"`r`n;!@InstallEnd@!`r`n"
$utf8BOM = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllText("config.txt", $config, $utf8BOM)

Write-Host "Concatenating binary..."
if (Test-Path SysTweakX.exe) { Remove-Item SysTweakX.exe -Force }
$out = [System.IO.File]::Create("SysTweakX.exe")
foreach ($f in @("7zSD.sfx", "config.txt", "app.7z")) {
    $bytes = [System.IO.File]::ReadAllBytes($f)
    $out.Write($bytes, 0, $bytes.Length)
}
$out.Close()

Write-Host "Done! SysTweakX.exe created locally."
