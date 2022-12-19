mode con:cols=50 lines=1
title Start work...

call :Clear>>Z:\Clear.log 2>&1
EXIT /b 0

:Clear
title Mount boot.wim
mkdir Z:\boot
dism /mount-image /imagefile:Z:\boot.wim /index:2 /mountdir:Z:\boot
title Load registry
reg load HKEY_LOCAL_MACHINE\WIM_BOOT Z:\boot\Windows\System32\config\SYSTEM
TIMEOUT /T 1 /NOBREAK >nul
title Disable TPM check
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassCPUCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassTPMCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassRAMCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassSecureBootCheck /t REG_DWORD /d 1
TIMEOUT /T 1 /NOBREAK >nul
title Unload registry
reg unload HKEY_LOCAL_MACHINE\WIM_BOOT
TIMEOUT /T 1 /NOBREAK >nul
title Unmount boot.wim
dism /unmount-wim /mountdir:Z:\boot /commit
TIMEOUT /T 1 /NOBREAK >nul
title Compress boot.wim
start /w Z:\WimOptimize.exe Z:\boot.wim
title Applying Clear.ps1
dism /get-imageinfo /imagefile:Z:\install.wim /index:10
if %ERRORLEVEL% EQU -1051328239 (
	del /f /q Z:\EN.txt
)
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -File Z:\Clear.ps1
title Load registry
reg load HKEY_LOCAL_MACHINE\WIM_SOFTWARE Z:\Install\Windows\System32\config\SOFTWARE
reg load HKEY_LOCAL_MACHINE\WIM_SYSTEM Z:\Install\Windows\System32\config\SYSTEM
reg load HKEY_LOCAL_MACHINE\WIM_CURRENT_USER Z:\Install\Users\Default\NTUSER.DAT
TIMEOUT /T 1 /NOBREAK >nul
title Applying Clear.reg
reg import Z:\Clear.reg
title Remove protect
call Z:\RegPermissions.bat HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.AllAppsDesktopApplication
call Z:\RegPermissions.bat HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.Computer
call Z:\RegPermissions.bat HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.DesktopPackagedApplication
call Z:\RegPermissions.bat HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.ImmersiveApplication
call Z:\RegPermissions.bat HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Launcher.SystemSettings
call Z:\RegPermissions.bat HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\IE.AssocFile.WEBSITE
call Z:\RegPermissions.bat HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Classes\Microsoft.Website
TIMEOUT /T 1 /NOBREAK >nul
title Unload registry
reg unload HKEY_LOCAL_MACHINE\WIM_CURRENT_USER
reg unload HKEY_LOCAL_MACHINE\WIM_SYSTEM
reg unload HKEY_LOCAL_MACHINE\WIM_SOFTWARE
title Hide NTUSER.DAT
ATTRIB Z:\Install\Users\Default\NTUSER.DAT +S +H
title Shortcuts
move "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\Character Map.lnk" "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools"
set DEL="Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\desktop.ini"
type %DEL%>>%DEL%.temp
del /f /q /a:sh %DEL%
move %DEL%.temp %DEL%
echo Character Map.lnk=@%SystemRoot%\system32\shell32.dll,-22021>>%DEL%
ATTRIB %DEL% +S +H
rd /s /q "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools"
move "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell ISE.lnk" "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools"
rd /s /q "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
rd /s /q "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Maintenance"
move "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools"
rd /s /q "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
rd /s /q "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Maintenance"
set DEL="Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\desktop.ini"
type %DEL%>>%DEL%.temp
del /f /q /a:sh %DEL%
move %DEL%.temp %DEL%
echo Administrative Tools.lnk=@%SystemRoot%\system32\shell32.dll,-21762>>%DEL%
echo File Explorer.lnk=@%SystemRoot%\system32\shell32.dll,-22067>>%DEL%
ATTRIB %DEL% +S +H
set DEL="Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\desktop.ini"
ATTRIB %DEL% -S -H
del /f /q %DEL%
move "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Administrative Tools.lnk" "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Administrative Tools.lnk"
move "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\File Explorer.lnk" "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk"
attrib +r -s -h "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessories" /S /D
title EdgeUpdate
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeCore"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeUpdate"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeWebView"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\100.0.1185.36\Installer"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\100.0.1185.36\elevation_service.exe"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\100.0.1185.36\notification_helper.exe"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\100.0.1185.36\notification_helper.exe.manifest"
title OneDrive
set DELETELIST=Z:\Install\Windows\WinSxS\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22621.1_none_86d60ce019ce7baf Z:\Install\Windows\WinSxS\amd64_microsoft-windows-s..lers-onedrivebackup_31bf3856ad364e35_10.0.22621.608_none_0a000b28f344090a\f Z:\Install\Windows\WinSxS\amd64_microsoft-windows-s..lers-onedrivebackup_31bf3856ad364e35_10.0.22621.608_none_0a000b28f344090a\r Z:\Install\Windows\WinSxS\amd64_microsoft-windows-s..lers-onedrivebackup_31bf3856ad364e35_10.0.22621.608_none_0a000b28f344090a Z:\Install\Windows\WinSxS\amd64_microsoft-windows-s..ivebackup.resources_31bf3856ad364e35_10.0.22621.1_ru-ru_d71d7f40692ef837
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	rd /s /q %%a
)
set DELETELIST=Z:\Install\Windows\System32\OneDriveSetup.exe Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22621.1_none_86d60ce019ce7baf.manifest Z:\Install\Windows\WinSxS\SettingsManifests\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22621.1_none_86d60ce019ce7baf.manifest Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-onedrive-setupregistry_31bf3856ad364e35_10.0.22621.1_none_51812954380458e2.manifest Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-onedrive-setupregistry_31bf3856ad364e35_10.0.22621.1_none_5bd5d3a66c651add.manifest Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.22621.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.22621.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.22621.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.22621.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.mum Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.22621.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.22621.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.22621.1.cat Z:\Install\Windows\System32\SettingsHandlers_OneDriveBackup.dll Z:\Install\Windows\System32\ru-RU\SettingsHandlers_OneDriveBackup.dll.mui Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-s..lers-onedrivebackup_31bf3856ad364e35_10.0.22621.608_none_0a000b28f344090a.manifest
for %%a in (%DELETELIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	del /f /q %%a
)
title UPFC
set DEL=Z:\Install\Windows\System32\upfc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\upfc.exe Z:\Install\Windows\System32
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
set DEL=Z:\Install\Windows\WinSxS\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.22621.1_none_08bb51571021559f
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.22621.1_none_08bb51571021559f.manifest
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title Calc
set DEL=Z:\Install\Windows\System32\calc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\calc.exe Z:\Install\Windows\System32
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
if exist Z:\Install\Windows\en-US\explorer.exe.mui (
	del /f /q Z:\EN.txt
	del /f /q Z:\calc.exe.cn.mui
	del /f /q Z:\calc.exe.ru.mui
	copy Z:\calc.exe.en.mui Z:\Install\Windows\System32\en-US\calc.exe.mui
	move Z:\calc.exe.en.mui Z:\Install\Windows\SysWOW64\en-US
)
if exist Z:\Install\Windows\zh-CN\explorer.exe.mui (
	del /f /q Z:\calc.exe.en.mui
	del /f /q Z:\calc.exe.ru.mui
	copy Z:\calc.exe.cn.mui Z:\Install\Windows\System32\zh-CN\calc.exe.mui
	move Z:\calc.exe.cn.mui Z:\Install\Windows\SysWOW64\zh-CN
)
if exist Z:\Install\Windows\ru-RU\explorer.exe.mui (
	del /f /q Z:\calc.exe.en.mui
	del /f /q Z:\calc.exe.cn.mui
	copy Z:\calc.exe.ru.mui Z:\Install\Windows\System32\ru-RU\calc.exe.mui
	move Z:\calc.exe.ru.mui Z:\Install\Windows\SysWOW64\ru-RU
)
set DEL=Z:\Install\Windows\WinSxS\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.22621.1_none_0b53ccef0e7a283c
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.22621.1_none_15a8774142daea37
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.22621.1_none_0b53ccef0e7a283c.manifest
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.22621.1_none_15a8774142daea37.manifest
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
set DEL=Z:\Install\Windows\SysWOW64\calc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\calc_64.exe Z:\Install\Windows\SysWOW64\calc.exe
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
title Block Defender Shell
set BLOCKLIST="Z:\Install\Program Files\Windows Defender\MpClient.dll" "Z:\Install\Program Files\Windows Defender\shellext.dll"
for %%a in (%BLOCKLIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
	icacls %%a /deny "*S-1-1-0:(W,D,X,R,RX,M,F)" "*S-1-5-7:(W,D,X,R,RX,M,F)"
)
title GameDVR
set DEL="Z:\Install\Windows\bcastdvr\KnownGameList.bin"
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\KnownGameList.bin %DEL%
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
title WaaS tasks
set DEL=Z:\Install\Windows\WaaS\regkeys
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WaaS\services
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WaaS
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\FileMaps\$$_waas_401032e7a18c2040.cdf-ms
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\FileMaps\$$_waas_regkeys_dbffc348a6fab71c.cdf-ms
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\FileMaps\$$_waas_services_ddfc4ae175ff1678.cdf-ms
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title Clear WinSxS
for /f "tokens=*" %%i in ('dir Z:\Install\Windows\WinSxS\Backup /b /a:-d') do (
	icacls "Z:\Install\Windows\WinSxS\Backup\%%~i" /grant "%username%":f /c /l /q
	del /f /q "Z:\Install\Windows\WinSxS\Backup\%%~i"
)
title Compress Winre
start /w Z:\WimOptimize.exe Z:\Install\Windows\System32\Recovery\Winre.wim
TIMEOUT /T 1 /NOBREAK >nul
title Copy PostClear
move Z:\PostClear Z:\Install\ProgramData\PostClear
title Unmounting
dism /unmount-wim /mountdir:Z:\Install /commit
title Done...
del /f /q Z:\Clear.ps1
del /f /q Z:\Clear.reg
del /f /q Z:\DISM.11.Scripts.zip
del /f /q Z:\RegPermissions.bat
del /f /q Z:\SubinAcl.exe
del /f /q Z:\WimOptimize.exe
del /f /q Z:\_Clear.bat
