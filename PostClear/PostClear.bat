mode con:cols=50 lines=1
title Start work...
call :PostClear>>%userprofile%\Desktop\PostClear.log 2>&1
EXIT /b 0
:PostClear
title Wait Explorer
taskkill /f /im explorer.exe
if exist %programdata%\PostClear\FirstLoad.reg (
	TIMEOUT /T 5 /NOBREAK >nul
	title Disable Defender
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\regedit.exe /CommandLine "/S %programdata%\PostClear\FirstLoad.reg" /RunAs 8 /WaitProcess 1 /Run
	%programdata%\PostClear\AdvancedRun.exe /EXEFilename %windir%\System32\WindowsPowerShell\v1.0\Powershell.exe /CommandLine "-executionpolicy remotesigned -File %programdata%\PostClear\FirstLoad.ps1" /RunAs 8 /WaitProcess 1 /Run
	TIMEOUT /T 1 /NOBREAK >nul
	del /f /q %programdata%\PostClear\FirstLoad.ps1
	del /f /q %programdata%\PostClear\FirstLoad.reg
	title Install VCLibs
	%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "Add-AppxPackage -Path %programdata%\PostClear\Microsoft.VCLibs.x64.14.00.Desktop.appx"
	%windir%\System32\WindowsPowerShell\v1.0\Powershell.exe -executionpolicy remotesigned -Command "Add-AppxPackage -Path %programdata%\PostClear\Microsoft.VCLibs.x86.14.00.Desktop.appx"
	TIMEOUT /T 1 /NOBREAK >nul
	del /f /q %programdata%\PostClear\Microsoft.VCLibs.x64.14.00.Desktop.appx
	del /f /q %programdata%\PostClear\Microsoft.VCLibs.x86.14.00.Desktop.appx
	title Install Start11
	start /w %programdata%\PostClear\Start11.exe /S
	TIMEOUT /T 1 /NOBREAK >nul
	del /f /q %programdata%\PostClear\Start11.exe
	goto Reboot
)
if exist %programdata%\PostClear\PostClearM.bat (
	call %programdata%\PostClear\PostClearM.bat
	del /f /q %programdata%\PostClear\PostClearM.bat
) else (
	for /F "skip=1 tokens=2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\InstallService" /V Start') do (if %%B equ 0x4 (title Press any key && start cmd /c "mode con:cols=60 lines=3 && title AppX Warning && echo off && echo "Microsoft Store Install Service" is Disabled! && echo Before create new account you must Enable AppX support. && pause" && pause))
	TIMEOUT /T 1 /NOBREAK >nul
)
title Applying PostClear.reg
start /w %windir%\regedit.exe /S %programdata%\PostClear\PostClear.reg
TIMEOUT /T 1 /NOBREAK >nul
title Fix translation
attrib +r -s -h "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessories" /S /D
TIMEOUT /T 1 /NOBREAK >nul
:Reboot
title Start Explorer
start %windir%\explorer.exe
TIMEOUT /T 2 /NOBREAK >nul
title Rebooting...
SHUTDOWN -r -t 3
