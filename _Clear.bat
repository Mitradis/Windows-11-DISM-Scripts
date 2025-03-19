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

title Disable TPM check
reg add HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig /v BypassCPUCheck /t REG_DWORD /d 1
reg add HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig /v BypassTPMCheck /t REG_DWORD /d 1
reg add HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig /v BypassRAMCheck /t REG_DWORD /d 1
reg add HKEY_LOCAL_MACHINE\WIM_BOOT\Setup\LabConfig /v BypassSecureBootCheck /t REG_DWORD /d 1

title Unload registry
reg unload HKEY_LOCAL_MACHINE\WIM_BOOT

title Unmount boot.wim
dism /unmount-wim /mountdir:Z:\boot /commit

title Compress boot.wim
if exist Z:\boot.wim (
	Z:\WimOptimize.exe Z:\boot.wim
) else (
	del /f /q Z:\boot.wim
)

title Applying _Clear.ps1
dism /get-imageinfo /imagefile:Z:\install.wim /index:10
if %ERRORLEVEL% EQU -1051328239 (
	del /f /q Z:\EN.txt
)
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy bypass -File Z:\_Clear.ps1
del /f /q Z:\EN.txt
del /f /q Z:\_Clear.ps1

title Load registry
reg load HKEY_LOCAL_MACHINE\WIM_SOFTWARE Z:\Install\Windows\System32\config\SOFTWARE
reg load HKEY_LOCAL_MACHINE\WIM_SYSTEM Z:\Install\Windows\System32\config\SYSTEM
reg load HKEY_LOCAL_MACHINE\WIM_CURRENT_USER Z:\Install\Users\Default\NTUSER.DAT

title Applying _Clear.reg
reg import Z:\_Clear.reg
del /f /q Z:\_Clear.reg

title Disable Secondary Logs
for /f "tokens=*" %%a in ('reg QUERY "HKEY_LOCAL_MACHINE\WIM_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels"') do (
	reg add "%%a" /v Enabled /t REG_DWORD /d 0 /f
)

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
rd /s /q "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
rd /s /q "Z:\Install\ProgramData\Microsoft\Windows\Start Menu\Programs\Maintenance"
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
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeUpdate"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeCore\122.0.2365.106"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\EdgeWebView\Application\122.0.2365.106"
rd /s /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\122.0.2365.106\Installer"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\122.0.2365.106\elevation_service.exe"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\122.0.2365.106\notification_helper.exe"
del /f /q "Z:\Install\Program Files (x86)\Microsoft\Edge\Application\122.0.2365.106\notification_helper.exe.manifest"

title Editing .dll`s
set DLLLIST=Z:\Install\Windows\System32\energyprov.dll Z:\Install\Windows\System32\umpoext.dll Z:\Install\Windows\System32\InputSwitch.dll Z:\Install\Windows\System32\upfc.exe Z:\Install\Windows\System32\calc.exe Z:\Install\Windows\SysWOW64\calc.exe Z:\Install\Windows\bcastdvr\KnownGameList.bin
for %%a in (%DLLLIST%) do (
	takeown /f %%a
	icacls %%a /grant "%username%":f /c /l /q
)
Z:\PostClear\HelpTool.exe Z:\Install\Windows\System32\energyprov.dll "2E 00 65 00 74 00 6C 00" "2E 00 3F 00 3F 00 3F 00"
Z:\PostClear\HelpTool.exe Z:\Install\Windows\System32\umpoext.dll "2E 00 65 00 74 00 6C 00" "2E 00 3F 00 3F 00 3F 00" *
Z:\PostClear\HelpTool.exe Z:\Install\Windows\System32\InputSwitch.dll "48 63 C7 48 8B CE 48 C1 E0 04 48 03 C2 8B D7 48 89 46 60 E8 BB 5B 00 00" "90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90"

title Add OneDrive
set DELETELIST=Z:\Install\Windows\System32\OneDriveSetup.exe Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.26100.1_none_2233e98c8e9ce5f5.manifest Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-onedrive-setupregistry_31bf3856ad364e35_10.0.26100.1_none_ecdf0600acd2c328.manifest Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-onedrive-setupregistry_31bf3856ad364e35_10.0.26100.1_none_f733b052e1338523.manifest Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.26100.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.26100.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.26100.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.26100.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.26100.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.26100.1.mum Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.26100.1.cat Z:\Install\Windows\servicing\Packages\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.26100.1.mum Z:\Install\Windows\WinSxS\SettingsManifests\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.26100.1_none_2233e98c8e9ce5f5.manifest Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~~10.0.26100.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-Package~31bf3856ad364e35~amd64~ru-RU~10.0.26100.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~~10.0.26100.1.cat Z:\Install\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\Microsoft-Windows-OneDrive-Setup-WOW64-Package~31bf3856ad364e35~amd64~ru-RU~10.0.26100.1.cat Z:\Install\Windows\WinSxS\amd64_microsoft-windows-onedrive-setup_31bf3856ad364e35_10.0.26100.1_none_2233e98c8e9ce5f5
title Add WaaS
set DELETELIST=%DELETELIST% Z:\Install\Windows\WinSxS\FileMaps\$$_waas_regkeys_dbffc348a6fab71c.cdf-ms Z:\Install\Windows\WinSxS\FileMaps\$$_waas_services_ddfc4ae175ff1678.cdf-ms Z:\Install\Windows\WaaS\regkeys Z:\Install\Windows\WaaS\services Z:\Install\Windows\WaaS
title Add UPFC
set DELETELIST=%DELETELIST% Z:\Install\Windows\System32\upfc.exe Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.26100.1150_none_430cd619cc4d0de3.manifest Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.26100.3323_none_42f3f4d7cc6040f1.manifest Z:\Install\Windows\WinSxS\amd64_microsoft-windows-upfc_31bf3856ad364e35_10.0.26100.3323_none_42f3f4d7cc6040f1
title Add calc
set DELETELIST=%DELETELIST% Z:\Install\Windows\System32\calc.exe Z:\Install\Windows\SysWOW64\calc.exe Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1_none_a6b1a99b83489282.manifest Z:\Install\Windows\WinSxS\Manifests\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1882_none_455c758bcadc235e.manifest Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1_none_b10653edb7a9547d.manifest Z:\Install\Windows\WinSxS\Manifests\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1882_none_4fb11fddff3ce559.manifest Z:\Install\Windows\WinSxS\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1_none_a6b1a99b83489282 Z:\Install\Windows\WinSxS\amd64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1882_none_455c758bcadc235e Z:\Install\Windows\WinSxS\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1_none_b10653edb7a9547d Z:\Install\Windows\WinSxS\wow64_microsoft-windows-calc_31bf3856ad364e35_10.0.26100.1882_none_4fb11fddff3ce559
title Add GameDVR
set DELETELIST=%DELETELIST% Z:\Install\Windows\bcastdvr\KnownGameList.bin
title Processing DELETELIST
for %%a in (%DELETELIST%) do (
	if exist %%a\ (
		Z:\PostClear\superUser64.exe /ws %windir%\System32\cmd.exe /c rd /s /q %%a
	) else (
		Z:\PostClear\superUser64.exe /ws %windir%\System32\cmd.exe /c del /f /q %%a
	)
)

title UPFC
move Z:\upfc.exe Z:\Install\Windows\System32

title Replace calc
move Z:\Calc\calc.exe Z:\Install\Windows\System32
move Z:\Calc\calc_64.exe Z:\Install\Windows\SysWOW64\calc.exe
if exist Z:\Install\Windows\ru-RU\explorer.exe.mui (
	Z:\PostClear\superUser64.exe /ws %windir%\System32\cmd.exe /c copy Z:\Calc\calc.exe.ru.mui Z:\Install\Windows\System32\ru-RU\calc.exe.mui
	move Z:\Calc\calc.exe.ru.mui Z:\Install\Windows\SysWOW64\ru-RU
)
if exist Z:\Install\Windows\en-US\explorer.exe.mui (
	Z:\PostClear\superUser64.exe /ws %windir%\System32\cmd.exe /c copy Z:\Calc\calc.exe.en.mui Z:\Install\Windows\System32\en-US\calc.exe.mui
	move Z:\Calc\calc.exe.en.mui Z:\Install\Windows\SysWOW64\en-US
)
if exist Z:\Install\Windows\zh-CN\explorer.exe.mui (
	Z:\PostClear\superUser64.exe /ws %windir%\System32\cmd.exe /c copy Z:\Calc\calc.exe.cn.mui Z:\Install\Windows\System32\zh-CN\calc.exe.mui
	move Z:\Calc\calc.exe.cn.mui Z:\Install\Windows\SysWOW64\zh-CN
)
rd /s /q Z:\Calc

title Copy WordPad
if exist Z:\Install\Windows\ru-RU\explorer.exe.mui (
	rd /s /q "Z:\WordPad\en-US"
) else (
	rd /s /q "Z:\WordPad\ru-RU"
)
xcopy /s Z:\WordPad "Z:\Install\Program Files\Windows NT\Accessories"
rd /s /q Z:\WordPad

title GameDVR
move Z:\KnownGameList.bin Z:\Install\Windows\bcastdvr

title Restore ACL
for %%a in (%DLLLIST%) do (
	%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows\System32\control.exe | Set-Acl -Path %%a"
)

title Disable Appx Protect
%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "& Get-Acl -Path Z:\Install\Windows | Set-Acl -Path 'Z:\Install\Program Files\WindowsApps'"

title Clear WinSxS
for /f "tokens=*" %%i in ('dir Z:\Install\Windows\WinSxS\Backup /b /a:-d') do (
	Z:\PostClear\superUser64.exe /ws %windir%\System32\cmd.exe /c del /f /q "Z:\Install\Windows\WinSxS\Backup\%%~i"
)

title Compress Winre
Z:\WimOptimize.exe Z:\Install\Windows\System32\Recovery\Winre.wim
del /f /q Z:\WimOptimize.exe

title Copy PostClear
if not exist Z:\Install\Windows\ru-RU\explorer.exe.mui (
	del /f /q Z:\PostClear\WinTool.html
)
move Z:\PostClear Z:\Install\ProgramData\PostClear

title Unmounting
dism /unmount-wim /mountdir:Z:\Install /commit

title Done...
del /f /q Z:\Windows-11-DISM-Scripts.rar
del /f /q Z:\_Clear.bat
