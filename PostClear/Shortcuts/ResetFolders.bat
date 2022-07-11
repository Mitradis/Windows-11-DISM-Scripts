@echo off
title Press any key to confirm
pause
title Work...
taskkill /f /im explorer.exe
mkdir %temp%\ResetFolders
reg export "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{7FDE1A1E-8B31-49A5-93B8-6BE14CFA4943}" %temp%\ResetFolders\1.reg /y
reg export "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{36011842-DCCC-40FE-AA3D-6177EA401788}" %temp%\ResetFolders\2.reg /y
reg export "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{4DCAFE13-E6A7-4C28-BE02-CA8C2126280D}" %temp%\ResetFolders\3.reg /y
reg export "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{71689AC1-CC88-45D0-8A22-2943C3E7DFB3}" %temp%\ResetFolders\4.reg /y
reg export "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{EA25FBD7-3BF7-409E-B97F-3352240903F4}" %temp%\ResetFolders\5.reg /y
reg delete "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell"
start /w %windir%\regedit.exe /S %temp%\ResetFolders\1.reg
start /w %windir%\regedit.exe /S %temp%\ResetFolders\2.reg
start /w %windir%\regedit.exe /S %temp%\ResetFolders\3.reg
start /w %windir%\regedit.exe /S %temp%\ResetFolders\4.reg
start /w %windir%\regedit.exe /S %temp%\ResetFolders\5.reg
rd /s /q %temp%\ResetFolders
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UFH\SHC" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UFH\SHC"
start explorer.exe
