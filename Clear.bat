mode con:cols=50 lines=1
title Start work...

call :Clear>>Z:\Clear.log 2>&1
EXIT /b 0

:Clear
title Mount boot.wim
mkdir Z:\boot
dism /mount-image /imagefile:Z:\boot.wim /index:2 /mountdir:Z:\boot
title Disable TPM check
reg load HKEY_LOCAL_MACHINE\WIM_BOOT Z:\boot\Windows\System32\config\SYSTEM
TIMEOUT /T 1 /NOBREAK >nul
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassCPUCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassTPMCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassRAMCheck /t REG_DWORD /d 1
reg add "HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig" /v BypassSecureBootCheck /t REG_DWORD /d 1
TIMEOUT /T 1 /NOBREAK >nul
reg unload HKEY_LOCAL_MACHINE\WIM_BOOT
TIMEOUT /T 1 /NOBREAK >nul
title Unmount boot.wim
dism /unmount-wim /mountdir:Z:\boot /commit
TIMEOUT /T 1 /NOBREAK >nul
title Compress boot.wim
start /w Z:\WimOptimize.exe Z:\boot.wim
title Applying Clear.ps1
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -File Z:\Clear.ps1
title Applying Clear.reg
reg load HKEY_LOCAL_MACHINE\WIM_SOFTWARE Z:\Install\Windows\System32\config\SOFTWARE
reg load HKEY_LOCAL_MACHINE\WIM_SYSTEM Z:\Install\Windows\System32\config\SYSTEM
reg load HKEY_LOCAL_MACHINE\WIM_CURRENT_USER Z:\Install\Users\Default\NTUSER.DAT
TIMEOUT /T 1 /NOBREAK >nul
start /w %windir%\regedit.exe /S Z:\Clear.reg
TIMEOUT /T 1 /NOBREAK >nul
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
del /f /q "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Administrative Tools.lnk"
del /f /q "Z:\Install\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\File Explorer.lnk"
title EdgeUpdate
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeCore"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeUpdate"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeWebView"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\90.0.818.66\Installer"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\90.0.818.66\elevation_service.exe"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\90.0.818.66\notification_helper.exe"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\90.0.818.66\notification_helper.exe.manifest"
title OneDrive
set DEL=Z:\Install\Windows\SysWOW64\OneDriveSetup.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\wow64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22000.1_none_85d889245f3a20db
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22000.1_none_85d889245f3a20db.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.22000.1_none_7b83ded22ad95ee0.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title UPFC
set DEL=Z:\Install\Windows\System32\upfc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\upfc.exe Z:\Install\Windows\System32
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
set DEL=Z:\Install\Windows\WinSxS\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.22000.708_none_a2a8640da17926e8
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.22000.708_none_a2a8640da17926e8.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-onecore-upfc-deployment_31bf3856ad364e35_10.0.22000.708_none_477b6fe72f853800.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title Calc
set DEL=Z:\Install\Windows\System32\calc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\calc.exe Z:\Install\Windows\System32
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
copy Z:\calc.exe.ru.mui Z:\Install\Windows\System32\ru-RU\calc.exe.mui
move Z:\calc.exe.ru.mui Z:\Install\Windows\SysWOW64\ru-RU
set DEL=Z:\Install\Windows\WinSxS\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.22000.653_none_a505ccb19fff0960
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.22000.653_none_a505ccb19fff0960.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
set DEL=Z:\Install\Windows\SysWOW64\calc.exe
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\calc_64.exe Z:\Install\Windows\SysWOW64\calc.exe
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
set DEL=Z:\Install\Windows\WinSxS\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.22000.653_none_af5a7703d45fcb5b
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.22000.653_none_af5a7703d45fcb5b.manifest
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
title GameDVR
set DEL="Z:\Install\Windows\bcastdvr\KnownGameList.bin"
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
del /f /q %DEL%
move Z:\KnownGameList.bin %DEL%
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %DEL%"
title Copy PostClear
move Z:\PostClear Z:\Install\ProgramData\PostClear
title WaaS tasks
set DEL=Z:\Install\Windows\WaaS\regkeys
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WaaS\services
takeown /f %DEL%
icacls %DEL% /grant "%username%":f /c /l /q
rd /s /q %DEL%
set DEL=Z:\Install\Windows\WaaS\tasks
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
set DEL=Z:\Install\Windows\WinSxS\FileMaps\$$_waas_tasks_0504086c7768f632.cdf-ms
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
title Unmounting
dism /unmount-wim /mountdir:Z:\Install /commit
title Done...
del /f /q Z:\Clear.ps1
del /f /q Z:\Clear.reg
del /f /q Z:\DISM.11.Scripts.zip
del /f /q Z:\WimOptimize.exe
del /f /q Z:\Clear.bat
